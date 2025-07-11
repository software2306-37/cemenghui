package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.entity.Tenant;
import com.cemenghui.service.impl.TenantServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TenantServiceImplTest {

    @Spy
    private TenantServiceImpl tenantService; // 用Spy而不是InjectMocks

    @Test
    @DisplayName("分页查询租户-有关键字")
    void testPageTenants_withKeyword() {
        Page<Tenant> page = new Page<>(1, 10);
        doReturn(page).when(tenantService).page(any(Page.class), any(QueryWrapper.class));
        Page<Tenant> result = tenantService.pageTenants(1, 10, "test");
        System.out.println("【分页查询租户-有关键字】预期: 非null, 实际: " + result);
        assertNotNull(result);
    }

    @Test
    @DisplayName("分页查询租户-无关键字")
    void testPageTenants_withoutKeyword() {
        Page<Tenant> page = new Page<>(1, 10);
        doReturn(page).when(tenantService).page(any(Page.class), any(QueryWrapper.class));
        Page<Tenant> result = tenantService.pageTenants(1, 10, null);
        System.out.println("【分页查询租户-无关键字】预期: 非null, 实际: " + result);
        assertNotNull(result);
    }

    @Test
    @DisplayName("租户标识存在性校验-存在")
    void testExistsByTenantCode_true() {
        doReturn(1L).when(tenantService).count(any(QueryWrapper.class));
        assertTrue(tenantService.existsByTenantCode("code1"));
    }

    @Test
    @DisplayName("租户标识存在性校验-不存在")
    void testExistsByTenantCode_false() {
        doReturn(0L).when(tenantService).count(any(QueryWrapper.class));
        assertFalse(tenantService.existsByTenantCode("code2"));
    }

    @Test
    @DisplayName("获取所有启用租户")
    void testListActiveTenants() {
        Tenant t1 = new Tenant();
        t1.setTenantName("A");
        Tenant t2 = new Tenant();
        t2.setTenantName("B");
        List<Tenant> tenants = Arrays.asList(t1, t2);
        doReturn(tenants).when(tenantService).list(any(QueryWrapper.class));
        List<Tenant> result = tenantService.listActiveTenants();
        System.out.println("【获取所有启用租户】预期: 2, 实际: " + result.size());
        assertEquals(2, result.size());
        assertEquals("A", result.get(0).getTenantName());
    }
} 