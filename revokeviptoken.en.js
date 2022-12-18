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
            <span><bold><h3>terminate:</h3></bold></span>
            <input id="terminate" type="checkbox">

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
