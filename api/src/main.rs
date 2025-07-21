use axum::{
    Extension, Router,
    routing::{get, post},
};
use handlers::{verify_email::verify_email, waitlist_signup::waitlist_signup};
use serde::Serialize;
use sqlx::sqlite::SqlitePoolOptions;
use std::error::Error;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};

mod handlers;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let db_url = dotenvy_macro::dotenv!("DATABASE_URL");

    let pool = SqlitePoolOptions::new()
        .max_connections(5)
        .connect(db_url)
        .await?;

    let app = Router::new()
        .route("/waitlist-signup", post(waitlist_signup))
        .route("/verify-email", get(verify_email))
        .layer(
            ServiceBuilder::new().layer(Extension(pool)).layer(
                CorsLayer::new()
                    .allow_headers(Any)
                    .allow_methods(Any)
                    .allow_origin(Any),
            ),
        );

    let listener = tokio::net::TcpListener::bind("127.0.0.1:4000")
        .await
        .unwrap();
    println!("listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();

    Ok(())
}

#[derive(Serialize)]
struct GenericResponse {
    success: bool,
    message: Option<&'static str>,
}

impl GenericResponse {
    fn ok() -> Self {
        Self {
            success: true,
            message: None,
        }
    }

    fn err() -> Self {
        Self {
            success: false,
            message: None,
        }
    }

    fn err_message(message: &'static str) -> Self {
        Self {
            success: false,
            message: Some(message),
        }
    }
}

// waitlist signup:
// 1. user fills out and submits form ✅
// 2. form data gets sent to server ✅
// 3. server makes new entry in waitlist table, with verified=false ✅
// 4. server sends email with link ✅
// 5. user clicks link which goes to another server endpoint
//    (api.resolveapp.net/verify-email?id=<ID>)
// 6. server reads id from query params, switches user to verified=true
// 7. server redirects user to a success page on website "Your email has been verified"
