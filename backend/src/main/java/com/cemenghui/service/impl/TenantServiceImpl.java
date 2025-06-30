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
        return null;
    }

    @Override
    public boolean existsByTenantCode(String tenantCode) {
        return false;
    }

    @Override
    public List<Tenant> listActiveTenants() {
        return null;
    }
}