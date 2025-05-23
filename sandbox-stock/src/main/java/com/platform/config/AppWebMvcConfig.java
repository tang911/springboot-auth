package com.platform.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.task.AsyncTaskExecutor;
import org.springframework.web.servlet.config.annotation.*;


@Configuration
public class AppWebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private PassionInterceptor interceptor;

    @Autowired
    @Qualifier("mvcAsyncTaskExecutor")
    private AsyncTaskExecutor asyncTaskExecutor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(interceptor).addPathPatterns("/**");
    }


    @Override
    public void configureAsyncSupport(AsyncSupportConfigurer configurer) {
        // 异步操作的超时时间，值为0或者更小，表示永不超时
        configurer.setDefaultTimeout(60_000);
        configurer.setTaskExecutor(asyncTaskExecutor);
    }
}

