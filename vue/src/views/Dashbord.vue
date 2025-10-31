<template>
  <div style="color:#666;font-size:14px;">
    <!-- 顶部统计卡片 -->
    <el-row :gutter="10" style="margin-bottom:12px">
      <el-col :span="8">
        <el-card>
          <div style="display:flex;justify-content:space-between;align-items:center">
            <div>
              <i class="el-icon-collection" />
              累计预测样本数
            </div>
            <el-link type="primary" :underline="false">详情明细</el-link>
          </div>
          <div style="padding:16px 0;text-align:center;font-weight:bold;font-size:22px">
            {{ total }}
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="12">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>高血压类型分布（柱状图）</span>
          </div>
          <div id="bp-bar" style="width:100%;height:420px;"></div>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>高血压分类占比（饼图）</span>
          </div>
          <div id="bp-pie" style="width:100%;height:420px;"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'Dashbord',
  data () {
    return {
      total: 0,
      labels: ['正常', '原发性', '继发性'], // 固定三类
      counts: [0, 0, 0],
      charts: { bar: null, pie: null }
    }
  },
  created () {
    // 统计总数
    this.request.get('/echarts/totle').then(res => {
      this.total = Number(res.data) || 0
    })
  },
  mounted () {
    this.initCharts()
    this.loadMembers()
    window.addEventListener('resize', this.onResize)
  },
  beforeDestroy () {
    window.removeEventListener('resize', this.onResize)
    if (this.charts.bar) this.charts.bar.dispose()
    if (this.charts.pie) this.charts.pie.dispose()
  },
  methods: {
    onResize () {
      if (this.charts.bar) this.charts.bar.resize()
      if (this.charts.pie) this.charts.pie.resize()
    },
    initCharts () {
      this.charts.bar = echarts.init(document.getElementById('bp-bar'))
      this.charts.pie = echarts.init(document.getElementById('bp-pie'))
    },
    loadMembers () {
      // 全局三类计数
      this.request.get('/echarts/members').then(res => {
        const arr = Array.isArray(res.data) ? res.data : []
        this.counts = [0, 0, 0].map((_, i) => Number(arr[i]) || 0)
        this.renderBar()
        this.renderPie()
      })
    },
    renderBar () {
      const option = {
        tooltip: { trigger: 'axis' },
        grid: { left: 40, right: 20, top: 30, bottom: 30 },
        xAxis: { type: 'category', data: this.labels },
        yAxis: { type: 'value' },
        series: [{
          type: 'bar',
          data: this.counts,
          barWidth: '40%'
        }]
      }
      this.charts.bar.setOption(option, true)
    },
    renderPie () {
      const option = {
        tooltip: { trigger: 'item' },
        legend: { orient: 'vertical', left: 'left', data: this.labels },
        series: [{
          name: '占比',
          type: 'pie',
          radius: '65%',
          center: ['50%', '55%'],
          data: this.labels.map((n, i) => ({ name: n, value: this.counts[i] })),
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.3)'
            }
          }
        }]
      }
      this.charts.pie.setOption(option, true)
    }
  }
}
</script>

<style scoped>
/* 可按需追加样式 */
</style>
