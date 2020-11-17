const state = {
  allShapes: []
};

const getters = {
  getAllShapes(state) {
    return state.allShapes;
  }
};

const actions = {
  async fetchAllShapes({ commit, rootState }) {
    let drizzleInstance = rootState.drizzle.drizzleInstance;
    let web3 = drizzleInstance.web3;
    let currentUser = rootState.accounts.activeAccount;

    let shapesCount = await drizzleInstance.contracts.Shapes.methods.getShapesArrayLength().call();

    let allShapesList = [];

    for (let i=0; i < shapesCount; i++) {
      // get shape data
      let currentShape = await drizzleInstance.contracts.Shapes.methods.getShapeByIndex(i).call();

      let name = web3.utils.hexToUtf8(currentShape[0]);
      let symbol = web3.utils.hexToUtf8(currentShape[1]);
      let supply = currentShape[2];
      let tokenId = currentShape[3];
      let priceWei = currentShape[4];
      let priceEth = web3.utils.fromWei(currentShape[4], "ether");
      let active = currentShape[5];

      // get current user's balance for this specific shape
      let userBalance = await drizzleInstance.contracts.Shapes.methods.balanceOf(currentUser, currentShape[3]).call();
        
      allShapesList.push({name, symbol, supply, tokenId, priceWei, priceEth, active, userBalance});
    }

    commit("setAllShapesList", allShapesList);
  }
};

const mutations = {
  setAllShapesList(state, aShapes) {
    state.allShapes = aShapes;
  }
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
};