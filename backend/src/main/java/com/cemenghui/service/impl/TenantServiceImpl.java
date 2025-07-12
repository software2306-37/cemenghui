package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.cemenghui.entity.Tenant;
import com.cemenghui.mapper.TenantMapper;
import com.cemenghui.service.TenantService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class TenantServiceImpl extends ServiceImpl<TenantMapper, Tenant> implements TenantService {

    @Override
    public Page<Tenant> pageTenants(int current, int size, String keyword) {
        Page<Tenant> page = new Page<>(current, size);
        QueryWrapper<Tenant> queryWrapper = new QueryWrapper<>();
        
        if (StringUtils.hasText(keyword)) {
            queryWrapper.and(wrapper -> 
                wrapper.like("tenant_code", keyword)
                    .or().like("tenant_name", keyword)
                    .or().like("contact_person", keyword)
                    .or().like("contact_phone", keyword)
            );
        }
        
        queryWrapper.orderByDesc("create_time");
        
        return this.page(page, queryWrapper);
    }

    @Override
    public boolean existsByTenantCode(String tenantCode) {
        QueryWrapper<Tenant> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("tenant_code", tenantCode);
        return this.count(queryWrapper) > 0;
    }

    @Override
    public List<Tenant> listActiveTenants() {
        QueryWrapper<Tenant> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 1)
                   .orderBy(true, true, "tenant_name");
        
        return this.list(queryWrapper);
    }
} 