import { axiosInstance, RequestAxios,ResponseType } from "basic"
import { Banner } from "../viewmodel"

// 获取轮播图
export const getBannerList= async ()=>{
return await RequestAxios.get<Banner[]>('/home/banner')
}