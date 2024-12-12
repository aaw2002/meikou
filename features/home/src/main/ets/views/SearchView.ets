import { window } from '@kit.ArkUI'
import { pageStack, SafeArea } from 'basic'

@Builder
function SearchViewBuilder() {
  NavDestination() {
    SearchView()
  }.hideTitleBar(true)
}

@Component
export struct SearchView {
  @StorageProp(SafeArea.TopHeight) safeTop: number = 0
  @State keyword: string = ''

  aboutToAppear(): void {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({ statusBarContentColor: '#FFFFFF' })
      })
  }

  aboutToDisappear(): void {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({ statusBarContentColor: '#000000' })
      })
  }

  build() {
    Column() {
      // search
      Row() {
        // 返回按钮
        Image($r('[basic].media.ic_public_left'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('[basic].color.white'))
          .margin(13)
          .onClick(() => {
            pageStack.pop();
          })
        Text(this.keyword)
        // 搜索框
        Search({ placeholder: '商品关键字...', value: $$this.keyword })
          .searchIcon({ src: $r('[basic].media.ic_public_search'), color: $r('[basic].color.gray') })
          .placeholderColor($r('[basic].color.gray'))
          .placeholderFont({ size: 14 })
          .searchButton('搜索', { fontSize: 14, fontColor: $r('[basic].color.red') })
          .backgroundColor($r('[basic].color.white'))
          .textFont({ size: 14 })
          .layoutWeight(1)
          .padding(0)
          .margin(0)
          .height(36)
          .caretStyle({ color: $r('[basic].color.red') })
          .defaultFocus(true)
          .onSubmit((value) => {
            pageStack.pushPath({ name: 'SearchResultView', param: this.keyword as string })
          })
      }
      .padding({ top: this.safeTop, right: 16 })
      .linearGradient({
        angle: 135,
        colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
      })

    }
  }
}