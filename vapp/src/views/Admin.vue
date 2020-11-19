<template>
<div v-if="isDrizzleInitialized">
  <b-container class="mt-3">

    <b-row>
      <b-col md="8" offset-md="2" class="text-center"> 
        <h1>Admin</h1>

        <p class="mt-4 mb-4">
          This is the page where the Shapes smart contract owner can perform tasks like adding a new Shape or 
          deactivating an existing one.
        </p>

        <b-alert show variant="warning" v-if="!isActiveUserAdmin">
          You are <strong>not</strong> the owner of the Shapes smart contract.
        </b-alert>
      </b-col>
    </b-row>

    <div v-if="isActiveUserAdmin">
      <hr>

      <b-row class="mt-4">
        <b-col md="8" offset-md="2" class="text-center">
          <h3>Add new shape</h3>
        </b-col>
      </b-row>
    </div>
  </b-container>
</div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "Admin",
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
