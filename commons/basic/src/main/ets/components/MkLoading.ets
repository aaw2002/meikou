@Component
export struct MkLoading {
  // 宽度可以由外部传入
  loadingWidth: number = 80

  build() {
    ImageAnimator()
      .images([
        { src: $r('app.media.loading_01') },
        { src: $r('app.media.loading_02') },
        { src: $r('app.media.loading_03') },
        { src: $r('app.media.loading_04') }
      ])
      .state(AnimationStatus.Running)
      .duration(199)
      .iterations(-1)
      .width(this.loadingWidth)
      .aspectRatio(3)
  }
}