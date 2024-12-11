import axios, { AxiosResponse } from "@ohos/axios";

export const axiosInstance = axios.create({
  baseURL: 'https://meikou-api.itheima.net',
  timeout: 20000
})

// 后端返回的数据格式 code, msg, result
export interface HttpResponse<T> {
  code: string
  msg: string
  result: T
}

export type ResponseType<T> = AxiosResponse<HttpResponse<T>>

export class RequestAxios {
  //get
  static get<T>(url: string, params?: object): Promise<ResponseType<T>> {
    return axiosInstance.get<null, ResponseType<T>>(url, { params:params })
  }

  //post
  static post<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return axiosInstance.post<null, ResponseType<T>>(url, {data:data});
  }

  //delete
  static delete<T>(url: string, data?: object) : Promise<ResponseType<T>>{
    return axiosInstance.post<null, ResponseType<T>>(url, { data:data });
  }

  //put
  static put<T>(url: string, data?: object) :Promise<ResponseType<T>>{
    return axiosInstance.post<null, ResponseType<T>>(url, { data:data });
  }
}