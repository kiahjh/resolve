use axum::{Extension, Json, http::StatusCode, response::IntoResponse};
use regex::Regex;
use resend_rs::{Resend, types::CreateEmailBaseOptions};
use serde::Deserialize;
use sqlx::{Pool, Sqlite};

use crate::GenericResponse;

#[derive(Deserialize)]
pub struct WaitlistSignupInput {
    email: String,
}

#[axum::debug_handler]
pub async fn waitlist_signup(
    Extension(pool): Extension<Pool<Sqlite>>,
    Json(input): Json<WaitlistSignupInput>,
) -> impl IntoResponse {
    let email_regex = Regex::new(r#"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#).unwrap();

    if !email_regex.is_match(&input.email) {
        return (
            StatusCode::BAD_REQUEST,
            Json(GenericResponse::err_message("Not a valid email")),
        );
    }

    let Ok(matching_email) = sqlx::query!(
        "SELECT COUNT(*) as count FROM waitlist WHERE email = $1;",
        input.email
    )
    .fetch_one(&pool)
    .await
    else {
        return (
            StatusCode::INTERNAL_SERVER_ERROR,
            Json(GenericResponse::err()),
        );
    };

    if matching_email.count > 0 {
        return (
            StatusCode::BAD_REQUEST,
            Json(GenericResponse::err_message("Email is already in waitlist")),
        );
    }

    let Ok(res) = sqlx::query!(
        "INSERT INTO waitlist (email) VALUES ($1) RETURNING id;",
        input.email
    )
    .fetch_one(&pool)
    .await
    else {
        return (
            StatusCode::INTERNAL_SERVER_ERROR,
            Json(GenericResponse::err()),
        );
    };

    let resend_key = dotenvy_macro::dotenv!("RESEND_KEY");
    let resend = Resend::new(resend_key);

    let from = "Resolve <resolve@resolveapp.net>";
    let to = [&input.email];
    let subject = "Verify your email for Resolve";
    let html = &format!(
        r#"<h1>Hi there!</h1><p>Just one more step to join the waitlist. Click the link below:</p><a href="http://localhost:4000/verify-email?id={}">Verify your email</a>"#,
        res.id
    );

    let email = CreateEmailBaseOptions::new(from, to, subject).with_html(html);

    let Ok(_) = resend.emails.send(email).await else {
        return (
            StatusCode::INTERNAL_SERVER_ERROR,
            Json(GenericResponse::err()),
        );
    };

    (StatusCode::OK, Json(GenericResponse::ok()))
}
