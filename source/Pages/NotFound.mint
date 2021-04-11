component Pages.NotFound {
  connect Theme exposing { textColor }
  style base {
    background-image: url("404-background.jpg");
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
    width: 100wh;
    height: 100vh;
    display: flex;
  }

  style centered {
    margin: auto;
    justify-content: center;
    align-items: center;
    text-align: center;
  }

  style title {
    color: #{textColor};
    font-size: 30px;
  }

  style number {
    color: #{textColor};
    font-size: 30px;
  }

  style image {
    margin: 16px;
  }

  style hover-display {
    transition: .5s ease;
    opacity: 0;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -40%);
    -ms-transform: translate(-50%, -40%);
    text-align: center;

    &:hover {
      opacity: 1;
    }
  }

  fun render : Html {
    <div::base>
      <div::centered>
        <h1::title>"Page not found"</h1>
        <div::number>"404"</div>
        <a href="/">
          <img::image src="/chest-empty.png" width="512" height="512"></img>
          <img::hover-display src="/coins.png" width="512" height="512"></img>
        </a>
      </div>
    </div>
  }
}
