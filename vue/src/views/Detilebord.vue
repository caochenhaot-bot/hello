<template>
  <div>
    <div style="margin: 10px 0">
      <el-input
          style="width: 200px"
          placeholder="请输入高血压类型"
          suffix-icon="el-icon-search"
          v-model="result"
      />
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>

      <!-- 批量删除 -->
      <el-popconfirm
          class="ml-5"
          confirm-button-text="确定"
          cancel-button-text="我再想想"
          icon="el-icon-info"
          icon-color="red"
          title="确定批量删除选中的记录吗？"
          @confirm="delBatch"
      >
        <el-button type="danger" slot="reference">批量删除</el-button>
      </el-popconfirm>
    </div>

    <el-table
        :data="tableData"
        border
        stripe
        :header-cell-class-name="'headerBg'"
        @selection-change="handleSelectionChange"
    >
      <!-- 勾选列（用于批量删除） -->
      <el-table-column type="selection" width="55" />

      <el-table-column prop="testid" label="病例ID" width="100" />
      <el-table-column prop="result" label="高血压类型" />
      <el-table-column prop="createTime" label="生成时间" />

      <el-table-column label="操作" width="300" align="center">
        <template slot-scope="scope">
          <el-button type="primary" @click="goSend()">应对措施</el-button>

          <!-- 单条删除 -->
          <el-popconfirm
              class="ml-5"
              confirm-button-text="确定"
              cancel-button-text="我再想想"
              icon="el-icon-info"
              icon-color="red"
              title="确定删除这条记录吗？"
              @confirm="del(scope.row.id)"
          >
            <el-button type="danger" slot="reference">删除</el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <div style="padding: 10px 0">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-sizes="[2, 5, 10, 20]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
      />
    </div>
  </div>
</template>

<script>
import { serverIp } from "../../public/config";

export default {
  name: "Detilebord",
  data() {
    return {
      serverIp,
      tableData: [],
      result: "",
      multipleSelection: [], // 勾选集合
      pageNum: 1,
      pageSize: 10,
      total: 0,
      id: this.$route.query.id1, // 可能按 testfileId 过滤
    };
  },
  created() {
    this.load();
  },
  methods: {
    load() {
      // 有 id 就按 id 过滤，没有就查全部
      const url =
          typeof this.id === "undefined"
              ? "/detilebord/page/"
              : `/detilebord/page/${this.id}`;

      this.request
          .get(url, {
            params: {
              pageNum: this.pageNum,
              pageSize: this.pageSize,
              result: this.result,
            },
          })
          .then((res) => {
            this.tableData = res.data.records || [];
            this.total = res.data.total || 0;
          });
    },

    // —— 新增：单条删除 ——
    del(id) {
      this.request.delete(`/detilebord/${id}`).then((res) => {
        if (res.code === "200") {
          this.$message.success("删除成功");
          this.load();
        } else {
          this.$message.error(res.msg || "删除失败");
        }
      });
    },

    // —— 新增：批量删除 ——
    delBatch() {
      const ids = this.multipleSelection.map((v) => v.id);
      if (!ids.length) {
        this.$message.warning("请先勾选要删除的记录");
        return;
      }
      this.request.post("/detilebord/del/batch", ids).then((res) => {
        if (res.code === "200") {
          this.$message.success("批量删除成功");
          this.load();
        } else {
          this.$message.error(res.msg || "批量删除失败");
        }
      });
    },

    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    reset() {
      this.result = "";
      this.load();
    },
    handleSizeChange(pageSize) {
      this.pageSize = pageSize;
      this.load();
    },
    handleCurrentChange(pageNum) {
      this.pageNum = pageNum;
      this.load();
    },
    goSend() {
      this.$router.push("/Send");
    },
  },
};
</script>

<style scoped></style>
