import { SafeArea } from "../constants/SafeArea"

@Component
export struct MkNavbar {
  // 顶部安全区域
  @StorageProp(SafeArea.TopHeight) safeTop: number = 0
  @Prop title: string = '分类标题';
  //左侧图标
  @Prop leftIcon: ResourceStr = $r('app.media.ic_public_left');
  //右侧图标
  @Prop rightIcon: ResourceStr = $r('app.media.ic_public_more');
  //是否显示左侧图标
  @Prop showLeftIcon: boolean = true;
  //是否显示右侧图标
  @Prop showRightIcon: boolean = false;
  //文字加图标颜色
  @Prop color: ResourceStr = $r('app.color.black');
  //背景色
  @Prop bg: ResourceStr = $r('app.color.white');
  //点击左侧图标
  onLeftIconClick: () => void = () => {
  };
  //点击右侧图标
  onRightIconClick: () => void = () => {
  };
  @BuilderParam TitleBuilder: () => void = this.titleBuilder;

  build() {
    Row() {
      Row() {
        if (this.showLeftIcon) {
          Image(this.leftIcon)
            .width(24)
            .aspectRatio(1)
            .fillColor(this.color)
            .onClick(() => {
              this.onLeftIconClick()
            })
        }
      }
      .width(50)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)

      this.TitleBuilder()


      Row() {
        if (this.showRightIcon) {
          Image(this.rightIcon)
            .width(24)
            .aspectRatio(1)
            .fillColor(this.color)
            .onClick(() => {
              this.onRightIconClick()
            })
        }
      }
      .width(50)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(50 + this.safeTop)
    .backgroundColor(this.bg)
    .padding({ top: this.safeTop })
  }

  @Builder
  titleBuilder() {
    Text(this.title)
      .fontSize(16)
      .fontWeight(500)
      .layoutWeight(1)
      .textAlign(TextAlign.Center)
  }
}