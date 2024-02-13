import VueCsrf from "vue-csrf"; export default { name: "Login", components: {},
data() { return { username: "", password: "", validationErrors: "", }; },
methods: { submitForm() { if (!this.username || !this.password) {
this.validationErrors = "Please input your credentials"; return; } // Call the
VueCsrf plugin to get the CSRF token VueCsrf.getCsrfToken().then((token) => {
axios .post( "http://localhost:8000/login/", { username: this.username,
password: this.password, }, { headers: { "Content-Type": "application/json", //
Add the CSRF token to the request header "X-CSRFToken": token, }, } )
.then((response) => { console.log(response); console.log(response.data);
localStorage.setItem("access_token", response.data.access_token);
axios.defaults.headers.common["Authorization"] = "Bearer " +
response.data.access; if (response.status === 200) { this.$router.push("/main");
} }) .catch((error) => { console.log(error); this.validationErrors =
error.response.data.message; }); }); }, }, };
