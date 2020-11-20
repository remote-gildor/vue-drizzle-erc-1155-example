<template>
  <section></section>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';

export default {
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance"]),
    ...mapGetters("accounts", ["activeAccount", "activeBalance"]),
  },
  methods: {
    ...mapActions("minter", ["fetchAllShapes"])
  },
  mounted() {
    const contractEventHandler = ({ contractName, eventName, data }) => {
      if (data._from == this.activeAccount) {
        let display = `${contractName}(${eventName}) - ${data}`;

        if (eventName === 'TokenMinted') {
          let symbol = this.drizzleInstance.web3.utils.hexToUtf8(data._symbol);
          display = "You have just bought 1 " + symbol + "! 💰🤑";
          this.$store.dispatch("minter/fetchAllShapes");
        } else if (eventName === 'TokenBurned') {
          let symbol = this.drizzleInstance.web3.utils.hexToUtf8(data._symbol);
          display = "You have just burned 1 " + symbol + "! 🔥😮";
          this.$store.dispatch("minter/fetchAllShapes");
        } else if (eventName === 'ShapeAdded') {
          let symbol = this.drizzleInstance.web3.utils.hexToUtf8(data._symbol);
          display = "Admin has added a new shape with a symbol " + symbol + ". 🆕";
          this.$store.dispatch("minter/fetchAllShapes");
        } else if (eventName === 'ShapeDeactivated') {
          let symbol = this.drizzleInstance.web3.utils.hexToUtf8(data._symbol);
          display = "Admin has deactivated the " + symbol + " shape. 🛑";
          this.$store.dispatch("minter/fetchAllShapes");
        }

        const subOptions = {
          theme: "bubble",
          position: "top-center", 
          duration: 5000,
          type: "success"
        };

        this.$toasted.show(display, subOptions);
      }  
    };

    this.$drizzleEvents.$on('drizzle/contractEvent', payload => {
      contractEventHandler(payload);
    });
  }
}
</script>
