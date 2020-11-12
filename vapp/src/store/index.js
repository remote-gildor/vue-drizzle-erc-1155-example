import Vue from 'vue';
import Vuex from 'vuex';
import minter from "./modules/minter";
import profile from "./modules/profile";

Vue.use(Vuex);

export default new Vuex.Store({
    modules: {
        minter,
        profile
    }
});
