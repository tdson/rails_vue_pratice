import Vue from 'vue/dist/vue.esm'
import Navbar from './components/navbar'
import Router from './router/router'

new Vue ({
  el: '#app',
  router: Router,
  components: { Navbar }
})
