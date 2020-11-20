<template>
    <div v-if="isDrizzleInitialized">
        <b-container class="mt-3">
            <b-row class="mt-4">
                <b-col md="4" offset-md="4" class="text-center">
                    <h1>Profile</h1>

                    <b-card class="mb-2">
                        <Gravatar class="img-fluid" :email="activeAccount" default-img="robohash" :size=200 />

                        <b-card-text class="mt-2">
                            <p>{{ activeAccount }}</p>
                            <p><strong>My ETH balance:</strong> {{ Number(getEthBalance).toFixed(4) }} ETH</p>
                        </b-card-text>

                        <router-link to="/minter">
                            <b-button variant="primary" href="/minter">Mint NFT tokens!</b-button>
                        </router-link>
                    </b-card>
                </b-col>
            </b-row>

            <div v-if="getUserShapes.length > 0">
                <hr>

                <h3 class="text-center mt-3">My NFTs</h3>
            </div>

            <b-card-group deck class="row mt-4 text-center">
                <b-col md="4" v-for="shape in getUserShapes" :key="shape.symbol"> 
                        <b-card header-tag="header" footer-tag="footer">
                            <template #header>
                                <h6 class="mb-1">Shape</h6>
                            </template>

                            <b-card-title>{{shape.name}} ({{shape.symbol}})</b-card-title>

                            <b-card-text class="m-4">
                                <b-icon :icon="shape.name" variant="primary" font-scale="5"></b-icon>
                            </b-card-text>

                            <b-button href="#" variant="danger" @click="burnShape(shape)">
                                Burn 1 {{shape.symbol}}
                            </b-button>

                            <template #footer>
                                <em>My balance: {{shape.userBalance}} {{shape.symbol}}</em>
                            </template>
                        </b-card>
                </b-col>
            </b-card-group>
        </b-container>
    </div>

    <div v-else>Loading...</div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Gravatar from "vue-gravatar";

export default {
    name: "Profile",
    components: {
        Gravatar
    },
    computed: {
        ...mapGetters("accounts", ["activeAccount", "activeBalance"]),
        ...mapGetters("drizzle", ["isDrizzleInitialized", "drizzleInstance"]),
        ...mapGetters('contracts', ['getContractData', 'contractInstances']),
        ...mapGetters("minter", ["getAllShapes"]),

        userAccount() {
            return this.activeAccount
        },
        getEthBalance() {
            return this.drizzleInstance.web3.utils.fromWei(this.activeBalance, "ether");
        },
        getUserShapes() {
            let userShapes = [];
            for (let shape of this.getAllShapes) {
                if (shape.userBalance > 0) {
                    userShapes.push(shape);
                }
            }
            return userShapes; 
        }
    },
    created() {
        this.$store.dispatch("minter/fetchAllShapes");
    },
    methods: {
        ...mapActions("minter", ["fetchAllShapes"]),
        ...mapActions("profile", ["burnShape"]),

        call(contract, method, args) {
            let key = this.drizzleInstance.contracts[contract].methods[method].cacheCall(...args)
            let value;

            try {
                value = this.contractInstances[contract][method][key].value;
            } catch (error) {
                value = null;
            }
            
            return value;
        },

        burnShape(shape) {
            this.drizzleInstance.contracts["Shapes"].methods["burnByTokenId"].cacheSend(shape.tokenId);
        }
    }
}
</script>

<style>

</style>