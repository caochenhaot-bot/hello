<template>
  <div>
    <div style="margin: 10px 0">
      <el-input style="width: 200px" placeholder="请输入名称" suffix-icon="el-icon-search" v-model="name"></el-input>
      <el-button class="ml-5" type="primary" @click="load">搜索</el-button>
      <el-button type="warning" @click="reset">重置</el-button>
    </div>

    <div style="margin: 10px 0">
      <el-upload
          :action="'http://' + serverIp + ':9090/DataTest/upload'"
          :show-file-list="false"
          accept="xlsx"
          :on-success="handleFileUploadSuccess"
          style="display: inline-block"
      >
        <el-button type="primary" class="ml-5">上传文件 <i class="el-icon-top"></i></el-button>
      </el-upload>

      <el-popconfirm
          class="ml-5"
          confirm-button-text="确定"
          cancel-button-text="我再想想"
          icon="el-icon-info"
          icon-color="red"
          title="您确定批量删除这些数据吗？"
          @confirm="delBatch"
      >
        <el-button type="danger" slot="reference">批量删除 <i class="el-icon-remove-outline"></i></el-button>
      </el-popconfirm>
    </div>

    <el-table
        :data="tableData"
        border
        stripe
        :header-cell-class-name="'headerBg'"
        @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column prop="name" label="文件名称"></el-table-column>
      <el-table-column prop="type" label="文件类型"></el-table-column>
      <el-table-column prop="size" label="文件大小(kb)"></el-table-column>

      <el-table-column label="在线预测">
        <template slot-scope="scope">
          <el-button type="primary" @click="star(scope.row.url)">在线预测</el-button>
        </template>
      </el-table-column>

      <el-table-column label="查看结果">
        <template slot-scope="scope">
          <el-button
              type="primary"
              @click="show(scope.row.id)"
              :disabled="scope.row.enable == null"
          >查看结果</el-button>
        </template>
      </el-table-column>

      <!-- ▼▼ 修改后的下载列：下拉菜单（原始文件/预测结果CSV/JSON） ▼▼ -->
      <el-table-column label="下载/导出">
        <template slot-scope="scope">
          <el-dropdown @command="cmd => handleDownload(scope.row, cmd)">
            <el-button type="primary">
              下载 <i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="raw" :disabled="!scope.row.jsonUrl">原始文件</el-dropdown-item>
              <el-dropdown-item command="csv">预测结果 CSV</el-dropdown-item>
              <el-dropdown-item command="json">预测结果 JSON</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
      <!-- ▲▲ 修改后的下载列 ▲▲ -->

      <el-table-column label="操作" width="200" align="center">
        <template slot-scope="scope">
          <el-popconfirm
              class="ml-5"
              confirm-button-text="确定"
              cancel-button-text="我再想想"
              icon="el-icon-info"
              icon-color="red"
              title="您确定删除吗？"
              @confirm="del(scope.row.id)"
          >
            <el-button type="danger" slot="reference">删除 <i class="el-icon-remove-outline"></i></el-button>
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
  name: "TestFile",
  data() {
    return {
      serverIp: serverIp,
      tableData: [],
      name: "",
      multipleSelection: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
    };
  },
  created() {
    this.load();
  },
  methods: {
    load() {
      this.request
          .get("/DataTest/page", {
            params: {
              pageNum: this.pageNum,
              pageSize: this.pageSize,
              name: this.name,
            },
          })
          .then((res) => {
            this.tableData = res.data.records;
            this.total = res.data.total;
          });
    },

    changeEnable(row) {
      this.request.post("/DataTest/update", row).then((res) => {
        if (res.code === "200") {
          this.$message.success("操作成功");
        }
      });
    },

    del(id) {
      this.request.delete("/DataTest/" + id).then((res) => {
        if (res.code === "200") {
          this.$message.success("删除成功");
          this.load();
        } else {
          this.$message.error("删除失败");
        }
      });
    },

    handleSelectionChange(val) {
      this.multipleSelection = val;
    },

    delBatch() {
      const ids = this.multipleSelection.map((v) => v.id);
      this.request.post("/DataTest/del/batch", ids).then((res) => {
        if (res.code === "200") {
          this.$message.success("批量删除成功");
          this.load();
        } else {
          this.$message.error("批量删除失败");
        }
      });
    },

    reset() {
      this.name = "";
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

    handleFileUploadSuccess(res) {
      if (res.code === "302") {
        this.$message.error("只能上传excel");
      } else {
        this.$message.success("上传成功");
      }
      this.load();
    },

    // 查看结果：跳到 /home，并带上 id
    show(id) {
      this.$router.push({
        path: "/home",
        query: { id },
      });
    },

    // 在线预测
    star(url) {
      url = url.slice(31);
      this.$message("在线预测中");
      this.request.get("DataTest/getUrl/" + url).then((res) => {
        if (res.code == "200") {
          this.$message.success("预测成功，请查看结果！");
          this.load();
        } else if (res.code === "505") {
          this.load();
          this.$message.success(res.msg);
        } else {
          this.load();
          this.$message.error("预测失败，请重新预测！");
        }
      });
    },

    // 原始文件下载（保留旧逻辑）
    download(jsonUrl) {
      const url = "http://localhost:9090/DataTest/" + jsonUrl;
      window.open(url);
      this.$router.push("/TestFile");
    },

    // 新增：统一处理下载（原始/导出）
    handleDownload(row, cmd) {
      // cmd: 'raw' | 'csv' | 'json'
      if (cmd === "raw") {
        if (!row.jsonUrl) {
          this.$message.warning("暂无原始文件可下载");
          return;
        }
        this.download(row.jsonUrl);
        return;
      }

      const fmt = cmd; // 'csv' | 'json'
      this.request
          .get("/export/predict", {
            params: { testfileId: row.id, fmt },
            responseType: "blob",
          })
          .then((res) => {
            const blob = new Blob([res], {
              type:
                  fmt === "json"
                      ? "application/json;charset=UTF-8"
                      : "text/csv;charset=UTF-8",
            });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = `predict_${row.id}.${fmt}`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
            this.$message.success("导出成功");
          })
          .catch(() => {
            this.$message.error("导出失败");
          });
    },
  },
};
</script>

<style scoped>
</style>
