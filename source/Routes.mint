routes {
  / {
    parallel {
      Stores.Api.Servers.Index.load()
      Stores.Api.Raids.Index.load()
      Application.load(Page::Home)
    }
  }

  * {
    Application.load(Page::NotFound)
  }
}
