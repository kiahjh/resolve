use axum::{
    Extension,
    extract::Query,
    response::{IntoResponse, Redirect, Response},
};
use dotenvy_macro::dotenv;
use serde::Deserialize;
use sqlx::{Pool, Sqlite};

#[derive(Deserialize)]
pub struct UserId {
    id: String,
}

#[axum::debug_handler]
pub async fn verify_email(
    Extension(pool): Extension<Pool<Sqlite>>,
    user_id: Query<UserId>,
) -> Response {
    let Ok(_) = sqlx::query!("SELECT * FROM waitlist WHERE id = $1;", user_id.id)
        .fetch_one(&pool)
        .await
    else {
        return Redirect::to(&format!("{}/error", dotenv!("WEB_ENDPOINT"))).into_response();
    };
    let Ok(_) = sqlx::query!("UPDATE waitlist SET verified = 1 WHERE id = $1", user_id.id)
        .execute(&pool)
        .await
    else {
        return Redirect::to(&format!("{}/error", dotenv!("WEB_ENDPOINT"))).into_response();
    };
    Redirect::to(&format!("{}/success", dotenv!("WEB_ENDPOINT"))).into_response()
}
