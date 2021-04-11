component Layout {
  connect Theme exposing { pageBackground, titleColor }

  property children : Array(Html) = []

  style base {
    background-color: #{pageBackground};
    min-height: calc(100vh - 78px);
    margin-top: 78px;

    padding-top: 8px;
  }

  fun render : Html {
    <>
    <Layout.Header height="78px"/>

    <div::base>

      <{ children }>
    </div>
    </>
  } 
}
