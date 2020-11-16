const state = {
  activeShapes: []
};

const getters = {
  getActiveShapes(state) {
    return state.activeShapes;
  }
};

const actions = {
  async fetchActiveShapes({ commit, rootState }) {
    let drizzleInstance = rootState.drizzle.drizzleInstance;
    let web3 = drizzleInstance.web3;

    let shapesCount = await drizzleInstance.contracts.Shapes.methods.getShapesArrayLength().call();

    let activeShapesList = [];

    for (let i=0; i < shapesCount; i++) {
      let currentShape = await drizzleInstance.contracts.Shapes.methods.getShapeByIndex(i).call();

      if (currentShape[5]) { // if shape is active, add it to the activeShapesList
        let name = web3.utils.hexToUtf8(currentShape[0]);
        let symbol = web3.utils.hexToUtf8(currentShape[1]);
        let supply = currentShape[2];
        let tokenId = currentShape[3];
        let priceWei = currentShape[4];
        let priceEth = web3.utils.fromWei(currentShape[4], "ether");
        let active = currentShape[5];
        
        activeShapesList.push({name, symbol, supply, tokenId, priceWei, priceEth, active});
      }
    }

    commit("setActiveShapesList", activeShapesList);
  }
};

const mutations = {
  setActiveShapesList(state, aShapes) {
    state.activeShapes = aShapes;
  }
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
};