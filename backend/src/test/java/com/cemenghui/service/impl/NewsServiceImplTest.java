package com.cemenghui.service.impl;

import static org.junit.jupiter.api.Assertions.*;



import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.entity.News;
import com.cemenghui.mapper.NewsMapper;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class NewsServiceImplTest {

    @Mock
    private NewsMapper newsMapper;

    @InjectMocks
    private NewsServiceImpl newsService;

    private News testNews;

    @BeforeEach
    void setUp() {
        testNews = new News();
        testNews.setId(1L);
        testNews.setTitle("Test News");
        testNews.setSummary("This is a test news summary");
        testNews.setAuthor("Test Author");
        testNews.setAuthorId(1L);
        testNews.setStatus(0);
        testNews.setViewCount(10);
        testNews.setCreateTime(LocalDateTime.now());
    }

    @Test
    void pageNews_WithKeyword_ShouldReturnFilteredResults() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, "Test", null, null);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertEquals("Test News", result.getRecords().get(0).getTitle());
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    @Test
    void pageNews_WithStatus_ShouldReturnFilteredResults() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, null, 0, null);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertEquals(0, result.getRecords().get(0).getStatus());
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    @Test
    void pageNews_WithAuthorId_ShouldReturnFilteredResults() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, null, null, 1L);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertEquals(1L, result.getRecords().get(0).getAuthorId());
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    @Test
    void pageNews_WithAllFilters_ShouldReturnFilteredResults() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, "Test", 0, 1L, "Sports", "2023-01-01", "2023-12-31");

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    @Test
    void pageNews_WithEmptyKeyword_ShouldNotApplyKeywordFilter() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, "", null, null);

        // Assert
        assertNotNull(result);
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    @Test
    void pageNews_WithNullStatus_ShouldNotApplyStatusFilter() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, null, null, null);

        // Assert
        assertNotNull(result);
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    @Test
    void pageNews_WithBoundaryPagination_ShouldHandleCorrectly() {
        // Test with minimum page values
        Page<News> expectedPage = new Page<>(1, 1);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        Page<News> result = newsService.pageNews(1, 1, null, null, null);
        assertNotNull(result);
        assertEquals(1, result.getSize());
        assertEquals(1, result.getCurrent());
    }

    @Test
    void auditNews_WithValidId_ShouldUpdateStatusAndAuditInfo() {
        // Arrange
        when(newsMapper.selectById(1L)).thenReturn(testNews);
        when(newsMapper.updateById(testNews)).thenReturn(1);

        // Act
        boolean result = newsService.auditNews(1L, 1, 2L);

        // Assert
        assertTrue(result);
        assertEquals(1, testNews.getStatus());
        assertEquals(2L, testNews.getAuditUserId());
        assertNotNull(testNews.getAuditTime());
    }

    @Test
    void auditNews_WithInvalidId_ShouldReturnFalse() {
        // Arrange
        when(newsMapper.selectById(999L)).thenReturn(null);

        // Act
        boolean result = newsService.auditNews(999L, 1, 2L);

        // Assert
        assertFalse(result);
        verify(newsMapper, never()).updateById(any());
    }

    @Test
    void auditNews_WithNullStatus_ShouldHandleGracefully() {
        // Arrange
        when(newsMapper.selectById(1L)).thenReturn(testNews);
        when(newsMapper.updateById(testNews)).thenReturn(1);

        // Act
        boolean result = newsService.auditNews(1L, null, 2L);

        // Assert
        assertTrue(result);
        assertNull(testNews.getStatus());
        assertEquals(2L, testNews.getAuditUserId());
        assertNotNull(testNews.getAuditTime());
    }

    @Test
    void incrementViewCount_WithValidId_ShouldIncreaseCount() {
        // Arrange
        when(newsMapper.selectById(1L)).thenReturn(testNews);
        when(newsMapper.updateById(testNews)).thenReturn(1);
        int initialCount = testNews.getViewCount();

        // Act
        newsService.incrementViewCount(1L);

        // Assert
        assertEquals(initialCount + 1, testNews.getViewCount());
    }

    @Test
    void incrementViewCount_WithNullViewCount_ShouldSetToOne() {
        // Arrange
        testNews.setViewCount(null);
        when(newsMapper.selectById(1L)).thenReturn(testNews);
        when(newsMapper.updateById(testNews)).thenReturn(1);

        // Act
        newsService.incrementViewCount(1L);

        // Assert
        assertEquals(1, testNews.getViewCount());
    }

    @Test
    void incrementViewCount_WithInvalidId_ShouldDoNothing() {
        // Arrange
        when(newsMapper.selectById(999L)).thenReturn(null);

        // Act
        newsService.incrementViewCount(999L);

        // Assert
        verify(newsMapper, never()).updateById(any());
    }

    @Test
    void pageNews_WithDateRange_ShouldApplyCorrectFilters() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, null, null, null, null, "2023-01-01", "2023-12-31");

        // Assert
        assertNotNull(result);
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    @Test
    void pageNews_WithOnlyStartDate_ShouldApplyStartDateFilter() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, null, null, null, null, "2023-01-01", null);

        // Assert
        assertNotNull(result);
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    @Test
    void pageNews_WithOnlyEndDate_ShouldApplyEndDateFilter() {
        // Arrange
        Page<News> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testNews));
        when(newsMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(expectedPage);

        // Act
        Page<News> result = newsService.pageNews(1, 10, null, null, null, null, null, "2023-12-31");

        // Assert
        assertNotNull(result);
        verify(newsMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }
}