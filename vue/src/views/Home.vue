<template>
  <div style="color:#666;font-size:14px;">
    <div style="padding-bottom:20px">
      <h1 style="text-align:center">
        <b>亲爱的{{ user.nickname }}，欢迎登录基于深度学习的高血压类型诊断系统</b>
      </h1>
    </div>

    <el-row :gutter="10" style="margin-bottom:5px">
      <el-col :span="6">
        <el-card style="color:#409EFF">
          <div><i class="el-icon-user-solid" />当前用户总数</div>
          <div style="padding:10px 0;text-align:center;font-weight:bold">{{ total }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card style="color:#409EFF;margin-bottom:50px">
          <div><i class="el-icon-user-solid" />累计预测样本数</div>
          <div style="padding:10px 0;text-align:center;font-weight:bold">{{ total2 }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card style="color:#409EFF;margin-bottom:50px">
          <div><i class="el-icon-user-solid" />今日预测样本数</div>
          <div style="padding:10px 0;text-align:center;font-weight:bold">{{ total1 }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card style="color:#409EFF;margin-bottom:50px">
          <div><i class="el-icon-user-solid" />最多的高血压类型</div>
          <div style="padding:10px 0;text-align:center;font-weight:bold">{{ topTypeText }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="12">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>{{ chartTitle }}</span>
          </div>
          <div id="tu" class="chart" :style="{width:'100%',height: chartHeight+'px'}"></div>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card shadow="hover">
          <div slot="header" class="clearfix">
            <span>每日上传/预测次数</span>
          </div>
          <div id="tu1" class="chart" :style="{width:'100%',height: chartHeight+'px'}"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'Home',
  data () {
    return {
      user: localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')) : {},
      total: 0,
      total1: 0,
      total2: 0,
      total3: 0,
      chartTitle: '高血压类型分布',
      idFromQuery: null,
      chartHeight: 420,
      charts: { left: null, right: null }
    }
  },
  computed: {
    topTypeText () {
      const map = { 0: '正常', 1: '原发性', 2: '继发性' }
      return Object.prototype.hasOwnProperty.call(map, this.total3) ? map[this.total3] : '-'
    }
  },
  created () {
    this.idFromQuery = this.$route.query.id ? Number(this.$route.query.id) : null
    this.load()
    this.load1()
    this.load2()
    this.load3()
  },
  mounted () {
    this.$nextTick(() => {
      this.initCharts()
      this.renderCharts()
      window.addEventListener('resize', this.onResize)
    })
  },
  beforeDestroy () {
    window.removeEventListener('resize', this.onResize)
    if (this.charts.left) this.charts.left.dispose()
    if (this.charts.right) this.charts.right.dispose()
  },
  watch: {
    '$route.query.id' () {
      this.idFromQuery = this.$route.query.id ? Number(this.$route.query.id) : null
      this.renderCharts()
    }
  },
  methods: {
    onResize () {
      if (this.charts.left) this.charts.left.resize()
      if (this.charts.right) this.charts.right.resize()
    },
    // 统计卡片
    load ()  { this.request.get('/user/totle').then(res => { this.total  = res.data || 0 }) },
    load2 () { this.request.get('/echarts/totle').then(res => { this.total2 = res.data || 0 }) },
    load1 () { this.request.get('/echarts/totle1').then(res => { this.total1 = res.data || 0 }) },
    load3 () { this.request.get('/echarts/totle3').then(res => { this.total3 = typeof res.data === 'number' ? res.data : 0 }) },

    // 初始化实例（只做一次）
    initCharts () {
      const leftEl = document.getElementById('tu')
      const rightEl = document.getElementById('tu1')
      if (!leftEl || !rightEl) return
      if (this.charts.left) this.charts.left.dispose()
      if (this.charts.right) this.charts.right.dispose()
      this.charts.left = echarts.init(leftEl)
      this.charts.right = echarts.init(rightEl)
    },

    // 渲染/更新图表
    renderCharts () {
      // 左：类型分布
      const hasId = !!this.idFromQuery
      const labels = ['正常', '原发性', '继发性']
      // ✅ 改为查询参数版，避免 /members/{id} 的 404
      const dataUrl = hasId
          ? `/echarts/membersByFile?testfileId=${this.idFromQuery}`
          : `/echarts/members`
      this.chartTitle = '高血压类型分布' + (hasId ? '（本次预测）' : '（全局汇总）')

      this.request.get(dataUrl).then(res => {
        const arr = Array.isArray(res.data) ? res.data : []
        const seriesData = arr.slice(0, 3).map(v => Number(v) || 0)
        const rawMax = Math.max.apply(null, [0].concat(seriesData))
        const maxVal = rawMax === 0 ? 1 : Math.ceil(rawMax * 1.2)

        const leftOpt = {
          polar: { radius: [10, '85%'] },
          angleAxis: { max: maxVal, startAngle: 75 },
          radiusAxis: { type: 'category', data: labels },
          tooltip: {},
          series: [{
            type: 'bar',
            data: seriesData,
            coordinateSystem: 'polar',
            label: { show: true, position: 'middle', formatter: '{b}: {c}' }
          }]
        }
        if (this.charts.left) {
          this.charts.left.setOption(leftOpt, true)
          this.charts.left.resize()
        }
      }).catch(err => {
        console.error('请求失败:', dataUrl, err)
      })

      // 右：每日上传/预测次数
      const rightOpt = {
        xAxis: { type: 'category', data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] },
        yAxis: { type: 'value' },
        series: [{ type: 'line', data: [], smooth: true }]
      }
      this.request.get('/home/members').then(res => {
        rightOpt.series[0].data = Array.isArray(res.data) ? res.data : []
        if (this.charts.right) {
          this.charts.right.setOption(rightOpt, true)
          this.charts.right.resize()
        }
      })
    }
  }
}
</script>

<style scoped>
.chart{
  width:100%;
  height:420px;
  min-height:320px;
}
</style>
