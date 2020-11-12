<template>
    <div>
        <div v-if="isDrizzleInitialized">
        <b-jumbotron header="Welcome to the Shapes website!" lead="Mint some NFTs here" class="text-center">
            <br>
            <p>Click the button below to see the Minter page</p>
            <router-link to="/minter">
                <b-button variant="primary" href="/minter">Mint NFT tokens!</b-button>
            </router-link>
        </b-jumbotron>
        </div>

        <div v-else>Loading...</div>
    </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
     name: "Home",
     computed: {
      ...mapGetters("drizzle", ["isDrizzleInitialized", "drizzleInstance"]),
     }
}
</script>

<style>

</style>