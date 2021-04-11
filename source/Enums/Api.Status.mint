enum Api.Status(a) {
  Error(Api.ErrorResponse)
  Loading
  Initial
  Ok(a)
}
