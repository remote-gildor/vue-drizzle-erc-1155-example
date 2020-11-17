<template>
<div>
  <div v-if="isDrizzleInitialized" id="app">
    <Navbar />

    <keep-alive>
      <router-view />
    </keep-alive>

    <Footer />

    <Toast />
  </div>

  <div v-else>
    <b-jumbotron header="Loading..." lead="Please check your MetaMask if this doesn't load soon." bg-variant="warning">
      <p>Make sure you have MetaMask installed and properly configured. Then click the button below to reload the website.</p>
      <b-button variant="dark" href="/">Reload page</b-button>
    </b-jumbotron>
  </div>
</div>
</template>

<script>
import { mapGetters } from 'vuex';
import Navbar from "./components/Navbar";
import Toast from "./components/Toast";
import Footer from "./components/Footer";

export default {
  name: 'app',
  components: {
    Navbar,
    Toast,
    Footer
  },
  computed: mapGetters('drizzle', ['isDrizzleInitialized'])
}
</script>

<style>
</style>
