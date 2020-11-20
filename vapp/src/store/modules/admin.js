const state = {
  contractEthBalance: 0
};

const getters = {
  getContractEthBalance(state) {
    return state.contractEthBalance;
  }
};

const actions = {
  async fetchContractEthBalance({ commit, rootState }) {
    let drizzleInstance = rootState.drizzle.drizzleInstance;
    let web3 = drizzleInstance.web3;
    let contractAddress = drizzleInstance.contracts.Shapes.address;

    window.console.log(contractAddress);
    window.console.log(drizzleInstance.contracts.Shapes);

    let balanceWei = await web3.eth.getBalance(contractAddress);
    let balance = web3.utils.fromWei(balanceWei, "ether");

    commit("setContractEthBalance", balance);
  }
};

const mutations = {
  setContractEthBalance(state, balance) {
    state.contractEthBalance = balance;
  }
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
};