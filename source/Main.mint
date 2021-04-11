component Main {
  connect Application exposing { page }

  fun render : Html {
    case (page) {
      Page::Initial => Html.empty()
      Page::Home => <Layout><Pages.Home/></Layout>
      Page::NotFound => <Pages.NotFound/>
    }
  }
}
