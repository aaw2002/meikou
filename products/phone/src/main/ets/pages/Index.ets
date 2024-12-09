import { BreakpointConstants, BreakPointKey, Log, SafeArea } from 'basic'
import { CartView } from 'cart'
import { CategoryView } from 'category'
import { HomeView } from 'home'
import { MyView } from 'my'

interface TabItem {
  text: string
  normal: ResourceStr
  active: ResourceStr
}

@Entry
@Component
struct Index {
  @StorageProp(SafeArea.TopHeight) topHeight: number = 0
  @StorageProp(SafeArea.BottomHeight) bottomHeight: number = 0
  @StorageProp(BreakPointKey) breakPoint: string = ''


  aboutToAppear(): void {

  }

  @State activeIndex: number = 0
  list: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]

  build() {

    Tabs({ barPosition: BarPosition.End }) {
      ForEach(this.list, (item: TabItem, index: number) => {
        TabContent() {

          if (index == 0) {
            HomeView()
          } else if (index == 1) {
            CategoryView()
          } else if (index == 2) {
            CartView()
          } else {
            MyView()
          }
        }
        .tabBar(this.TabItemBuilder(item, index))
      })
    }
    .barPosition(this.breakPoint == BreakpointConstants.LG ? BarPosition.Start : BarPosition.End)
    .vertical(this.breakPoint == BreakpointConstants.LG ? true : false)
    .padding({ top: this.topHeight, bottom: this.bottomHeight })
    .scrollable(false)
    .onTabBarClick(index => {
      animateTo({duration:500},()=>{
        this.activeIndex = index
      })
    })
  }

  @Builder
  TabItemBuilder(item: TabItem, index: number) {
    Column() {
      Image(this.activeIndex === index ? item.active : item.normal)
        .width(24)
        .aspectRatio(1)
      Text(item.text)// 跨 HSP 访问资源，需要在 oh-package.json5中导入
        .fontColor($r('[basic].color.black'))
        .fontSize(12)
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(50)
  }
}