//<![CDATA[
class Token {

    constructor(tokenInstance) {
        this.props = tokenInstance;
    }

    render() {
        return`
        <div class="ui container">
          <div class="ui segment">
          <img src="data:image/png;base64,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">
            <span><bold><h3>VIPaddress:</h3></bold></span>
            <input id="VIPaddress" type="text">

          </div>
        </div>
        `;
    }
}

web3.tokens.dataChanged = (oldTokens, updatedTokens, tokenIdCard) => {
    const currentTokenInstance = web3.tokens.data.currentInstance;
    document.getElementById(tokenIdCard).innerHTML = new Token(currentTokenInstance).render();
};
//]]>
