import Vue from 'vue/dist/vue.esm'
import Router from './router/router'
import Navbar from './components/navbar'

var app = new Vue({
  el: '#app',
  router: Router,
  components: {
    Navbar
  }
})
