<template>
<div v-if="isDrizzleInitialized">
  <b-container class="mt-3">

    <b-row>
      <b-col md="8" offset-md="2" class="text-center"> 
        <h1>Minter</h1>

        <p class="mt-4 mb-4">
          Here you can mint yourself some ERC-1155 tokens. Tokens are separated into "categories" (Shapes). 
          One token can only belong to one Shape. But one Shape can hold many tokens.
        </p>
      </b-col>
    </b-row>

    <b-card-group deck class="row">
      <b-col md="4" class="text-center mt-3" v-for="shape in getAllShapes" :key="shape.symbol"> 
        <div v-if="shape.active">
          <b-card header-tag="header" footer-tag="footer">
            <template #header>
              <h6 class="mb-0">Shape</h6>
            </template>

            <b-card-title>{{shape.name}} ({{shape.symbol}})</b-card-title>

            <b-card-text class="m-4">
              <b-icon :icon="shape.name" variant="primary" font-scale="5"></b-icon>
            </b-card-text>

            <b-button href="#" variant="primary" @click="mintShape(shape)">
              Mint for {{shape.priceEth}} ETH
            </b-button>

            <template #footer>
              <em>Circulating supply: {{shape.supply}} {{shape.symbol}}</em>
            </template>
          </b-card>
        </div>
      </b-col>
    </b-card-group>

  </b-container>
</div>

<div v-else>Loading...</div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";

export default {
    name: "Minter",
    computed: {
      ...mapGetters("accounts", ["activeAccount", "activeBalance"]),
      ...mapGetters("drizzle", ["isDrizzleInitialized", "drizzleInstance"]),
      ...mapGetters("minter", ["getAllShapes"]),
    },
    methods: {
      ...mapActions("minter", ["fetchAllShapes"]),
      mintShape(shape) {
        this.drizzleInstance.contracts['Shapes'].methods['mintByTokenId'].cacheSend(
          shape.tokenId, 
          this.drizzleInstance.web3.utils.hexToBytes("0x0000000000000000000000000000000000000000"), 
          {
            from: this.activeAccount,
            value: shape.priceWei
          }
        )
      }
    },
    created() {
      this.$store.dispatch("minter/fetchAllShapes");
    }
}
</script>

<style>

</style>