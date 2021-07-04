import axios from "axios";

const element = document.getElementsByName("csrf-token")[0] as HTMLMetaElement;
axios.defaults.headers.common["X-CSRF-TOKEN"] = element.content;
const client = axios.create();

export default client;
