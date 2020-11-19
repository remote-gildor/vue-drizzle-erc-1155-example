<template>
    <!-- NAVBAR -->
    <b-navbar toggleable="lg" type="dark" variant="primary">
        <router-link to="/">
            <b-navbar-brand href="/">Shapes</b-navbar-brand>
        </router-link>

        <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav>
        <!-- Right aligned nav items -->
        <b-navbar-nav class="ml-auto">

            <router-link to="/minter"><b-nav-item href="/minter">Minter</b-nav-item></router-link>
            <router-link to="/profile"><b-nav-item href="/profile">Profile</b-nav-item></router-link>
            <router-link v-if="isActiveUserAdmin" to="/admin"><b-nav-item href="/admin">Admin</b-nav-item></router-link>

        </b-navbar-nav>
        </b-collapse>
    </b-navbar>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "Navbar",
  computed: {
    ...mapGetters("accounts", ["activeAccount", "activeBalance"]),
    ...mapGetters("contracts", ["getContractData"]),
    ...mapGetters("drizzle", ["isDrizzleInitialized", "drizzleInstance"]),

    isActiveUserAdmin() {
        let owner = this.getContractData({
          contract: "Shapes",
          method: "owner"
        });

        if (owner === "loading") return "0";

        if (owner === this.activeAccount) {
          return true;
        } else {
          return false;
        }
      }
  },
  created() {
    this.$store.dispatch("drizzle/REGISTER_CONTRACT", {
      contractName: "Shapes",
      method: "owner",
      methodArgs: []
    });
  }
}
</script>

<style>

</style>