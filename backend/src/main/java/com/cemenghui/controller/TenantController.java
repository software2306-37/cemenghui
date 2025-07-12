package com.cemenghui.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.common.Result;
import com.cemenghui.entity.Tenant;
import com.cemenghui.entity.User;
import com.cemenghui.service.TenantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/tenant")
public class TenantController {

    @Autowired
    private TenantService tenantService;

    /**
     * 分页查询租户列表
     */
    @GetMapping("/page")
    public Result<Page<Tenant>> pageTenants(@RequestParam(defaultValue = "1") int current,
                                          @RequestParam(defaultValue = "10") int size,
                                          @RequestParam(required = false) String keyword) {
        Page<Tenant> page = tenantService.pageTenants(current, size, keyword);
        return Result.success(page);
    }

    /**
     * 获取租户详情
     */
    @GetMapping("/{id}")
    public Result<Tenant> getTenant(@PathVariable Long id) {
        Tenant tenant = tenantService.getById(id);
        if (tenant != null) {
            return Result.success(tenant);
        } else {
            return Result.error("租户不存在");
        }
    }

    /**
     * 创建租户
     */
    @PostMapping
    public Result<String> createTenant(@RequestBody Tenant tenant, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            return Result.error(403, "无权限操作");
        }
        
        // 检查租户标识是否已存在
        if (tenantService.existsByTenantCode(tenant.getTenantCode())) {
            return Result.error("租户标识已存在");
        }
        
        if (tenantService.save(tenant)) {
            return Result.success("创建成功");
        } else {
            return Result.error("创建失败");
        }
    }

    /**
     * 更新租户
     */
    @PutMapping("/{id}")
    public Result<String> updateTenant(@PathVariable Long id, @RequestBody Tenant tenant, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            return Result.error(403, "无权限操作");
        }
        
        Tenant existingTenant = tenantService.getById(id);
        if (existingTenant == null) {
            return Result.error("租户不存在");
        }
        
        // 如果修改了租户标识，检查新标识是否已存在
        if (!existingTenant.getTenantCode().equals(tenant.getTenantCode()) 
            && tenantService.existsByTenantCode(tenant.getTenantCode())) {
            return Result.error("租户标识已存在");
        }
        
        tenant.setId(id);
        if (tenantService.updateById(tenant)) {
            return Result.success("更新成功");
        } else {
            return Result.error("更新失败");
        }
    }

    /**
     * 删除租户
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteTenant(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            return Result.error(403, "无权限操作");
        }
        
        if (tenantService.removeById(id)) {
            return Result.success("删除成功");
        } else {
            return Result.error("删除失败");
        }
    }

    /**
     * 获取所有启用的租户列表
     */
    @GetMapping("/list")
    public Result<List<Tenant>> listActiveTenants() {
        List<Tenant> tenants = tenantService.listActiveTenants();
        return Result.success(tenants);
    }

    /**
     * 小程序端获取租户展示列表 - 只返回基本信息
     */
    @GetMapping("/miniapp/list")
    public Result<List<Tenant>> getMiniappTenantList(@RequestParam(defaultValue = "0") int limit) {
        List<Tenant> tenants = tenantService.listActiveTenants();
        // 如果limit大于0，则限制返回数量；否则返回所有数据
        if (limit > 0 && tenants.size() > limit) {
            tenants = tenants.subList(0, limit);
        }
        return Result.success(tenants);
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> export(@RequestParam(required = false) String keyword) {
        try {
            QueryWrapper<Tenant> queryWrapper = new QueryWrapper<>();
            
            if (StringUtils.hasText(keyword)) {
                queryWrapper.and(wrapper -> wrapper
                    .like("tenant_code", keyword)
                    .or().like("tenant_name", keyword)
                    .or().like("contact_person", keyword)
                    .or().like("contact_phone", keyword)
                );
            }
            
            queryWrapper.orderByDesc("create_time");
            
            List<Tenant> tenantList = tenantService.list(queryWrapper);
            
            // 简化的CSV导出
            StringBuilder csv = new StringBuilder();
            // 添加UTF-8 BOM头
            csv.append("\uFEFF");
            csv.append("TenantCode,TenantName,ContactPerson,ContactPhone,Status,CreateTime\n");
            
            for (Tenant tenant : tenantList) {
                csv.append(tenant.getTenantCode() != null ? tenant.getTenantCode() : "").append(",")
                   .append(tenant.getTenantName() != null ? tenant.getTenantName().replace(",", ";") : "").append(",")
                   .append(tenant.getContactPerson() != null ? tenant.getContactPerson() : "").append(",")
                   .append(tenant.getContactPhone() != null ? tenant.getContactPhone() : "").append(",")
                   .append(tenant.getStatus() == 1 ? "Active" : "Inactive").append(",")
                   .append(tenant.getCreateTime() != null ? tenant.getCreateTime() : "").append("\n");
            }
            
            byte[] data = csv.toString().getBytes("UTF-8");
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            String fileName = "tenants_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".csv";
            headers.setContentDispositionFormData("attachment", fileName);
            
            return ResponseEntity.ok()
                .headers(headers)
                .body(data);
                
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
} 