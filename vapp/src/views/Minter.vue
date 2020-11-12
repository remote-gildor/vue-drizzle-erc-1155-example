<template>
<div v-if="isDrizzleInitialized">
  <b-container class="mt-3">

    <b-row>
      <b-col md="4" offset-md="4" class="text-center"> 
        <h1>Minter</h1>
      </b-col>
    </b-row>

    <b-row class="mt-4">
      <b-col md="4" offset-md="4" class="text-center">
        <b-card title="Mint NFTs" sub-title="Enter the amount of ETH to invest">
          <b-form @submit.prevent="onSubmit">
            <b-form-group id="input-group-1" label-for="minter-ether-field">

              <b-input-group append="ETH" class="mt-4 mb-2">
                <b-form-input 
                  id="minter-ether-field" 
                  v-model="ethValue" 
                  type="text" 
                  required 
                  placeholder="0.0"
                  trim
                >
                </b-form-input>
                
              </b-input-group>

              <b-button class="mt-2" type="submit" variant="primary">Submit</b-button>
            </b-form-group>
          </b-form>
        </b-card>
      </b-col>
    </b-row>
  </b-container>
</div>

<div v-else>Loading...</div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
    name: "Crowdsale",
    computed: {
      ...mapGetters("accounts", ["activeAccount", "activeBalance"]),
      ...mapGetters("contracts", ["getContractData"]),
      ...mapGetters("drizzle", ["isDrizzleInitialized", "drizzleInstance"]),
    },
    methods: {
      // buy tokens with ETH
      onSubmit() {
        window.console.log("SUBMIT CLICKED");
      }
    },
    created() {

    },
    data() {
      return {
        ethValue: "1"
      }
    }
}
</script>

<style>

</style>