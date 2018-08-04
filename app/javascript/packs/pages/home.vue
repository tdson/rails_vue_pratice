<template>
  <div>
    <div>
      <ul class="collection">
        <li id="row_task_1" class="collection-item">
          <input type="checkbox" id="task_1" />
          <label for="task_1">Sample Task</label>
        </li>
        <li id="row_task_2" class="collection-item">
          <input type="checkbox" id="task_2" />
          <label for="task_2">Sample Task</label>
        </li>
        <li id="row_task_3" class="collection-item">
          <input type="checkbox" id="task_3" />
          <label for="task_3">Sample Task</label>
        </li>
      </ul>
    </div>
    <div class="btn">Display finished tasks</div>
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <li id="row_task_4" class="collection-item">
          <input type="checkbox" id="'task_4" checked="checked" />
          <label v-bind:for="task_4" class="line-through">Done Task</label>
        </li>
        <li id="row_task_5" class="collection-item">
          <input type="checkbox" id="'task_5" checked="checked" />
          <label v-bind:for="task_5" class="line-through">Done Task</label>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data: function () {
    return {
      tasks: []
    }
  },

  computed: {
    finishedTasks: function () {
      return this.tasks.filter(task => task.is_done)
    },

    unfinishedTasks: function () {
      return this.tasks.filter(task => !task.is_done)
    }
  },

  mounted: function () {
    this.fetchTasks()
  },

  methods: {
    fetchTasks: function () {
      axios.get('/api/tasks').then(
        response => { this.tasks = response.data.tasks },
        error => alert(error)
      )
    }
  }
}
</script>
