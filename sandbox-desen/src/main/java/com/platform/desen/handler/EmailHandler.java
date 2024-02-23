package com.platform.desen.handler;

import cn.hutool.core.util.DesensitizedUtil;
import org.springframework.stereotype.Component;

/**
 * @Description
 * @Author kaiyang
 * @Date 2024-02-22 6:35 PM
 */

@Component
public class EmailHandler extends AbstractMaskHandler implements MaskHandler{


    public int getStartIdx(String matcherGroupStr) {
        return 0;
    }

    public int getEndIdx(String matcherGroupStr) {
        return 0;
    }

    public String regrex(String str) {
        return null;
    }

    public String keyword(String str) {
        return DesensitizedUtil.email(str);
    }



}
