package com.cemenghui.controller;

import com.cemenghui.common.Result;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@RestController
@RequestMapping("/file")
public class FileController {

    private static final String UPLOAD_DIR = System.getProperty("user.dir") + "/backend/src/main/resources/static/uploads/";

    /**
     * 文件上传
     */
    @PostMapping("/upload")
    public Result<String> uploadFile(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("文件不能为空");
        }

        try {
            // 创建上传目录
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 生成唯一文件名
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String filename = UUID.randomUUID().toString() + extension;

            // 保存文件
            File dest = new File(UPLOAD_DIR + filename);
            file.transferTo(dest);

            // 返回文件访问路径
            String fileUrl = "/uploads/" + filename;
            return Result.success("上传成功", fileUrl);
        } catch (IOException e) {
            return Result.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * 多文件上传
     */
    @PostMapping("/uploads")
    public Result<String[]> uploadFiles(@RequestParam("files") MultipartFile[] files) {
        if (files.length == 0) {
            return Result.error("文件不能为空");
        }

        try {
            // 创建上传目录
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String[] fileUrls = new String[files.length];
            for (int i = 0; i < files.length; i++) {
                MultipartFile file = files[i];
                if (!file.isEmpty()) {
                    // 生成唯一文件名
                    String originalFilename = file.getOriginalFilename();
                    String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                    String filename = UUID.randomUUID().toString() + extension;

                    // 保存文件
                    File dest = new File(UPLOAD_DIR + filename);
                    file.transferTo(dest);

                    // 保存文件访问路径
                    fileUrls[i] = "/uploads/" + filename;
                }
            }

                    return Result.success("上传成功", fileUrls);
    } catch (IOException e) {
        return Result.error("上传失败：" + e.getMessage());
    }
}

/**
 * 测试文件访问
 */
@GetMapping("/test/{filename}")
public Result<String> testFile(@PathVariable String filename) {
    File file = new File(UPLOAD_DIR + filename);
    if (file.exists()) {
        return Result.success("文件存在", "/uploads/" + filename);
    } else {
        return Result.error("文件不存在：" + file.getAbsolutePath());
    }
}
} 