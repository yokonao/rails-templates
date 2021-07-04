import { createBrowserHistory } from "history";
import React from "react";
import ReactDOM from "react-dom";
import { Switch, Route, Router } from "react-router";

const history = createBrowserHistory();
const Hoge = () => <div>hogehoge</div>;
const Fuga = () => <div>fugafuga</div>;
const App = (): JSX.Element => {
  return (
    <div>
      <h1>BookingSample</h1>
      hello react on rails
      <Router history={history}>
        <Switch>
          <Route path="/hoge" component={Hoge}></Route>
          <Route path="/fuga" component={Fuga}></Route>
        </Switch>
      </Router>
    </div>
  );
};

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <App />,
    document.body.appendChild(document.createElement("div"))
  );
});
