<template>
<div v-if="isDrizzleInitialized">
  <b-container class="mt-3">

    <!-- INTRO -->
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

      <!-- ADD A NEW SHAPE -->
      <b-row class="mt-2">
        <b-col md="4" offset-md="4" class="text-center">
          <b-card title="Add new shape">
            <b-form @submit.prevent="addNewShape">
              <b-form-group>

                <b-input-group prepend="Name:" class="mt-4 mb-2">
                  <b-form-input 
                    v-model="addShapeName" 
                    type="text" 
                    required 
                    placeholder="E.g. Square"
                    trim
                  >
                  </b-form-input>
                </b-input-group>

                <b-input-group prepend="Symbol:" class="mt-4 mb-2">
                  <b-form-input 
                    v-model="addShapeSymbol" 
                    type="text" 
                    required 
                    placeholder="E.g. SQR"
                    trim
                  >
                  </b-form-input>
                </b-input-group>

                <b-input-group append="ETH" prepend="Shape price:" class="mt-4 mb-2">
                  <b-form-input 
                    v-model="addShapePrice" 
                    type="text" 
                    required 
                    placeholder="E.g. 1.4"
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

      <!-- DEACTIVATE A SHAPE -->
      <b-row class="mt-2">
        <b-col md="4" offset-md="4" class="text-center">
          <b-card title="Deactivate a Shape">
            <b-form @submit.prevent="deactivateShape">
              <b-form-group>

                <b-input-group prepend="Symbol:" class="mt-4 mb-2">
                  <b-form-input 
                    v-model="deactivateShapeSymbol" 
                    type="text" 
                    required 
                    placeholder="E.g. SQR"
                    trim
                  >
                  </b-form-input>
                </b-input-group>

                <b-button class="mt-2" type="submit" variant="danger">Deactivate {{deactivateShapeSymbol}}</b-button>
              </b-form-group>
            </b-form>
          </b-card>
        </b-col>
      </b-row>

      <!-- COLLECT ETH -->
      <b-row class="mt-2">
        <b-col md="4" offset-md="4" class="text-center">
          <b-card title="Collect ETH from the Shape contract">

            <p>Current balance: {{getContractEthBalance}} ETH</p>

            <b-form @submit.prevent="collectEth">
              <b-form-group>
                <b-button class="mt-2" type="submit" variant="success">Collect {{getContractEthBalance}} ETH</b-button>
              </b-form-group>
            </b-form>
          </b-card>
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
    ...mapGetters("admin", ["getContractEthBalance"]),

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

    this.$store.dispatch("admin/fetchContractEthBalance");
  },
  data() { 
    return {
      addShapeName: null,
      addShapeSymbol: null,
      addShapePrice: 0,
      deactivateShapeSymbol: null
    }
  },
  methods: {
    addNewShape() {
      this.drizzleInstance.contracts['Shapes'].methods['addNewShape'].cacheSend(
        this.drizzleInstance.web3.utils.asciiToHex(this.addShapeName),
        this.drizzleInstance.web3.utils.asciiToHex(this.addShapeSymbol),
        this.drizzleInstance.web3.utils.toWei(this.addShapePrice, 'ether')
      );
    },
    collectEth() {
      this.drizzleInstance.contracts['Shapes'].methods['ownerCollectEther'].cacheSend();
    },
    deactivateShape() {
      this.drizzleInstance.contracts['Shapes'].methods['deactivateShapeBySymbol'].cacheSend(
        this.drizzleInstance.web3.utils.asciiToHex(this.deactivateShapeSymbol)
      );
    }
  }
}
</script>

<style>

</style>
