package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.cemenghui.entity.Tenant;

import java.util.List;

public interface TenantService extends IService<Tenant> {
    
    /**
     * 分页查询租户
     */
    Page<Tenant> pageTenants(int current, int size, String keyword);
    
    /**
     * 检查租户标识是否存在
     */
    boolean existsByTenantCode(String tenantCode);
    
    /**
     * 获取所有启用的租户
     */
    List<Tenant> listActiveTenants();
} 