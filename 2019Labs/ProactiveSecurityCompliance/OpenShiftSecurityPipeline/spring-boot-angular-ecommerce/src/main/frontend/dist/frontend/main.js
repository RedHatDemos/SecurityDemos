(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["main"],{

/***/ "./src/$$_lazy_route_resource lazy recursive":
/*!**********************************************************!*\
  !*** ./src/$$_lazy_route_resource lazy namespace object ***!
  \**********************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

function webpackEmptyAsyncContext(req) {
	// Here Promise.resolve().then() is used instead of new Promise() to prevent
	// uncaught exception popping up in devtools
	return Promise.resolve().then(function() {
		var e = new Error('Cannot find module "' + req + '".');
		e.code = 'MODULE_NOT_FOUND';
		throw e;
	});
}
webpackEmptyAsyncContext.keys = function() { return []; };
webpackEmptyAsyncContext.resolve = webpackEmptyAsyncContext;
module.exports = webpackEmptyAsyncContext;
webpackEmptyAsyncContext.id = "./src/$$_lazy_route_resource lazy recursive";

/***/ }),

/***/ "./src/app/app.component.css":
/*!***********************************!*\
  !*** ./src/app/app.component.css ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = ".container {\n    padding-top: 65px;\n}\n"

/***/ }),

/***/ "./src/app/app.component.html":
/*!************************************!*\
  !*** ./src/app/app.component.html ***!
  \************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<div class=\"container\">\n    <app-ecommerce></app-ecommerce>\n</div>\n"

/***/ }),

/***/ "./src/app/app.component.ts":
/*!**********************************!*\
  !*** ./src/app/app.component.ts ***!
  \**********************************/
/*! exports provided: AppComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppComponent", function() { return AppComponent; });
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _ecommerce_services_EcommerceService__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./ecommerce/services/EcommerceService */ "./src/app/ecommerce/services/EcommerceService.ts");
var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};


var AppComponent = /** @class */ (function () {
    function AppComponent() {
    }
    AppComponent = __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["Component"])({
            selector: 'app-root',
            template: __webpack_require__(/*! ./app.component.html */ "./src/app/app.component.html"),
            styles: [__webpack_require__(/*! ./app.component.css */ "./src/app/app.component.css")],
            providers: [_ecommerce_services_EcommerceService__WEBPACK_IMPORTED_MODULE_1__["EcommerceService"]]
        })
    ], AppComponent);
    return AppComponent;
}());



/***/ }),

/***/ "./src/app/app.module.ts":
/*!*******************************!*\
  !*** ./src/app/app.module.ts ***!
  \*******************************/
/*! exports provided: AppModule */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppModule", function() { return AppModule; });
/* harmony import */ var _angular_platform_browser__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/platform-browser */ "./node_modules/@angular/platform-browser/fesm5/platform-browser.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_forms__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/forms */ "./node_modules/@angular/forms/fesm5/forms.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var _app_component__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./app.component */ "./src/app/app.component.ts");
/* harmony import */ var _ecommerce_ecommerce_component__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./ecommerce/ecommerce.component */ "./src/app/ecommerce/ecommerce.component.ts");
/* harmony import */ var _ecommerce_products_products_component__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./ecommerce/products/products.component */ "./src/app/ecommerce/products/products.component.ts");
/* harmony import */ var _ecommerce_shopping_cart_shopping_cart_component__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./ecommerce/shopping-cart/shopping-cart.component */ "./src/app/ecommerce/shopping-cart/shopping-cart.component.ts");
/* harmony import */ var _ecommerce_orders_orders_component__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./ecommerce/orders/orders.component */ "./src/app/ecommerce/orders/orders.component.ts");
/* harmony import */ var _ecommerce_services_EcommerceService__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ./ecommerce/services/EcommerceService */ "./src/app/ecommerce/services/EcommerceService.ts");
var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};










var AppModule = /** @class */ (function () {
    function AppModule() {
    }
    AppModule = __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["NgModule"])({
            declarations: [
                _app_component__WEBPACK_IMPORTED_MODULE_4__["AppComponent"],
                _ecommerce_ecommerce_component__WEBPACK_IMPORTED_MODULE_5__["EcommerceComponent"],
                _ecommerce_products_products_component__WEBPACK_IMPORTED_MODULE_6__["ProductsComponent"],
                _ecommerce_shopping_cart_shopping_cart_component__WEBPACK_IMPORTED_MODULE_7__["ShoppingCartComponent"],
                _ecommerce_orders_orders_component__WEBPACK_IMPORTED_MODULE_8__["OrdersComponent"]
            ],
            imports: [
                _angular_platform_browser__WEBPACK_IMPORTED_MODULE_0__["BrowserModule"],
                _angular_common_http__WEBPACK_IMPORTED_MODULE_3__["HttpClientModule"],
                _angular_forms__WEBPACK_IMPORTED_MODULE_2__["FormsModule"],
                _angular_forms__WEBPACK_IMPORTED_MODULE_2__["ReactiveFormsModule"]
            ],
            providers: [_ecommerce_services_EcommerceService__WEBPACK_IMPORTED_MODULE_9__["EcommerceService"]],
            bootstrap: [_app_component__WEBPACK_IMPORTED_MODULE_4__["AppComponent"]]
        })
    ], AppModule);
    return AppModule;
}());



/***/ }),

/***/ "./src/app/ecommerce/ecommerce.component.css":
/*!***************************************************!*\
  !*** ./src/app/ecommerce/ecommerce.component.css ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/ecommerce/ecommerce.component.html":
/*!****************************************************!*\
  !*** ./src/app/ecommerce/ecommerce.component.html ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<nav class=\"navbar navbar-expand-lg navbar-dark bg-dark fixed-top\">\n    <div class=\"container\">\n        <a class=\"navbar-brand\" href=\"#\">Ecommerce</a>\n        <button class=\"navbar-toggler\" type=\"button\" data-toggle=\"collapse\"\n                data-target=\"#navbarResponsive\" aria-controls=\"navbarResponsive\"\n                aria-expanded=\"false\" aria-label=\"Toggle navigation\" (click)=\"toggleCollapsed()\">\n            <span class=\"navbar-toggler-icon\"></span>\n        </button>\n        <div id=\"navbarResponsive\" [ngClass]=\"{'collapse': collapsed, 'navbar-collapse': true}\">\n            <ul class=\"navbar-nav ml-auto\">\n                <li class=\"nav-item active\">\n                    <a class=\"nav-link\" href=\"#\" (click)=\"reset()\">Home\n                        <span class=\"sr-only\">(current)</span>\n                    </a>\n                </li>\n            </ul>\n        </div>\n    </div>\n</nav>\n<div class=\"row\">\n    <div class=\"col-md-9\">\n        <app-products #productsC [hidden]=\"orderFinished\"></app-products>\n    </div>\n    <div class=\"col-md-3\">\n        <app-shopping-cart (onOrderFinished)=finishOrder($event) #shoppingCartC\n                           [hidden]=\"orderFinished\"></app-shopping-cart>\n    </div>\n    <div class=\"col-md-6 offset-3\">\n        <app-orders #ordersC [hidden]=\"!orderFinished\"></app-orders>\n    </div>\n</div>\n"

/***/ }),

/***/ "./src/app/ecommerce/ecommerce.component.ts":
/*!**************************************************!*\
  !*** ./src/app/ecommerce/ecommerce.component.ts ***!
  \**************************************************/
/*! exports provided: EcommerceComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "EcommerceComponent", function() { return EcommerceComponent; });
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _products_products_component__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./products/products.component */ "./src/app/ecommerce/products/products.component.ts");
/* harmony import */ var _shopping_cart_shopping_cart_component__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./shopping-cart/shopping-cart.component */ "./src/app/ecommerce/shopping-cart/shopping-cart.component.ts");
/* harmony import */ var _orders_orders_component__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./orders/orders.component */ "./src/app/ecommerce/orders/orders.component.ts");
var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (undefined && undefined.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};




var EcommerceComponent = /** @class */ (function () {
    function EcommerceComponent() {
        this.collapsed = true;
        this.orderFinished = false;
    }
    EcommerceComponent.prototype.ngOnInit = function () {
    };
    EcommerceComponent.prototype.toggleCollapsed = function () {
        this.collapsed = !this.collapsed;
    };
    EcommerceComponent.prototype.finishOrder = function (orderFinished) {
        this.orderFinished = orderFinished;
    };
    EcommerceComponent.prototype.reset = function () {
        this.orderFinished = false;
        this.productsC.reset();
        this.shoppingCartC.reset();
        this.ordersC.paid = false;
    };
    __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["ViewChild"])('productsC'),
        __metadata("design:type", _products_products_component__WEBPACK_IMPORTED_MODULE_1__["ProductsComponent"])
    ], EcommerceComponent.prototype, "productsC", void 0);
    __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["ViewChild"])('shoppingCartC'),
        __metadata("design:type", _shopping_cart_shopping_cart_component__WEBPACK_IMPORTED_MODULE_2__["ShoppingCartComponent"])
    ], EcommerceComponent.prototype, "shoppingCartC", void 0);
    __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["ViewChild"])('ordersC'),
        __metadata("design:type", _orders_orders_component__WEBPACK_IMPORTED_MODULE_3__["OrdersComponent"])
    ], EcommerceComponent.prototype, "ordersC", void 0);
    EcommerceComponent = __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["Component"])({
            selector: 'app-ecommerce',
            template: __webpack_require__(/*! ./ecommerce.component.html */ "./src/app/ecommerce/ecommerce.component.html"),
            styles: [__webpack_require__(/*! ./ecommerce.component.css */ "./src/app/ecommerce/ecommerce.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], EcommerceComponent);
    return EcommerceComponent;
}());



/***/ }),

/***/ "./src/app/ecommerce/models/product-order.model.ts":
/*!*********************************************************!*\
  !*** ./src/app/ecommerce/models/product-order.model.ts ***!
  \*********************************************************/
/*! exports provided: ProductOrder */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "ProductOrder", function() { return ProductOrder; });
var ProductOrder = /** @class */ (function () {
    function ProductOrder(product, quantity) {
        this.product = product;
        this.quantity = quantity;
    }
    return ProductOrder;
}());



/***/ }),

/***/ "./src/app/ecommerce/models/product-orders.model.ts":
/*!**********************************************************!*\
  !*** ./src/app/ecommerce/models/product-orders.model.ts ***!
  \**********************************************************/
/*! exports provided: ProductOrders */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "ProductOrders", function() { return ProductOrders; });
var ProductOrders = /** @class */ (function () {
    function ProductOrders() {
        this.productOrders = [];
    }
    return ProductOrders;
}());



/***/ }),

/***/ "./src/app/ecommerce/orders/orders.component.css":
/*!*******************************************************!*\
  !*** ./src/app/ecommerce/orders/orders.component.css ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/ecommerce/orders/orders.component.html":
/*!********************************************************!*\
  !*** ./src/app/ecommerce/orders/orders.component.html ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<h2 class=\"text-center\">ORDER</h2>\n<ul>\n    <li *ngFor=\"let order of orders.productOrders\">\n        {{ order.product.name }} - ${{ order.product.price }} x {{ order.quantity}} pcs.\n    </li>\n</ul>\n<h3 class=\"text-right\">Total amount: ${{ total }}</h3>\n\n<button class=\"btn btn-primary btn-block\" (click)=\"pay()\" *ngIf=\"!paid\">Pay</button>\n\n<div class=\"alert alert-success\" role=\"alert\" *ngIf=\"paid\">\n    <strong>Congratulation!</strong> You successfully made the order.\n</div>\n"

/***/ }),

/***/ "./src/app/ecommerce/orders/orders.component.ts":
/*!******************************************************!*\
  !*** ./src/app/ecommerce/orders/orders.component.ts ***!
  \******************************************************/
/*! exports provided: OrdersComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "OrdersComponent", function() { return OrdersComponent; });
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _services_EcommerceService__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../services/EcommerceService */ "./src/app/ecommerce/services/EcommerceService.ts");
var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (undefined && undefined.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};


var OrdersComponent = /** @class */ (function () {
    function OrdersComponent(ecommerceService) {
        this.ecommerceService = ecommerceService;
        this.orders = this.ecommerceService.ProductOrders;
    }
    OrdersComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.paid = false;
        this.sub = this.ecommerceService.OrdersChanged.subscribe(function () {
            _this.orders = _this.ecommerceService.ProductOrders;
        });
        this.loadTotal();
    };
    OrdersComponent.prototype.pay = function () {
        this.paid = true;
        this.ecommerceService.saveOrder(this.orders).subscribe();
    };
    OrdersComponent.prototype.loadTotal = function () {
        var _this = this;
        this.sub = this.ecommerceService.TotalChanged.subscribe(function () {
            _this.total = _this.ecommerceService.Total;
        });
    };
    OrdersComponent = __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["Component"])({
            selector: 'app-orders',
            template: __webpack_require__(/*! ./orders.component.html */ "./src/app/ecommerce/orders/orders.component.html"),
            styles: [__webpack_require__(/*! ./orders.component.css */ "./src/app/ecommerce/orders/orders.component.css")]
        }),
        __metadata("design:paramtypes", [_services_EcommerceService__WEBPACK_IMPORTED_MODULE_1__["EcommerceService"]])
    ], OrdersComponent);
    return OrdersComponent;
}());



/***/ }),

/***/ "./src/app/ecommerce/products/products.component.css":
/*!***********************************************************!*\
  !*** ./src/app/ecommerce/products/products.component.css ***!
  \***********************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = ".padding-0 {\n    padding-right: 0;\n    padding-left: 1;\n}\n"

/***/ }),

/***/ "./src/app/ecommerce/products/products.component.html":
/*!************************************************************!*\
  !*** ./src/app/ecommerce/products/products.component.html ***!
  \************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<div class=\"row card-deck\">\n    <div class=\"col-lg-4 col-md-6 mb-4\" *ngFor=\"let order of productOrders\">\n        <div class=\"card text-center\">\n            <div class=\"card-header\">\n                <h4>{{order.product.name}}</h4>\n            </div>\n            <div class=\"card-body\">\n                <a href=\"#\"><img class=\"card-img-top\" src={{order.product.pictureUrl}} alt=\"\"></a>\n                <h5 class=\"card-title\">${{order.product.price}}</h5>\n                <div class=\"row\">\n                    <div class=\"col-4 padding-0\" *ngIf=\"!isProductSelected(order.product)\">\n                        <input type=\"number\" min=\"0\" class=\"form-control\" [(ngModel)]=order.quantity>\n                    </div>\n                    <div class=\"col-4 padding-0\" *ngIf=\"!isProductSelected(order.product)\">\n                        <button class=\"btn btn-primary\" (click)=\"addToCart(order)\"\n                                [disabled]=\"order.quantity <= 0\">Add To Cart\n                        </button>\n                    </div>\n                    <div class=\"col-12\" *ngIf=\"isProductSelected(order.product)\">\n                        <button class=\"btn btn-primary btn-block\"\n                                (click)=\"removeFromCart(order)\">Remove From Cart\n                        </button>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</div>\n"

/***/ }),

/***/ "./src/app/ecommerce/products/products.component.ts":
/*!**********************************************************!*\
  !*** ./src/app/ecommerce/products/products.component.ts ***!
  \**********************************************************/
/*! exports provided: ProductsComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "ProductsComponent", function() { return ProductsComponent; });
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _models_product_order_model__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../models/product-order.model */ "./src/app/ecommerce/models/product-order.model.ts");
/* harmony import */ var _services_EcommerceService__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../services/EcommerceService */ "./src/app/ecommerce/services/EcommerceService.ts");
var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (undefined && undefined.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var ProductsComponent = /** @class */ (function () {
    function ProductsComponent(ecommerceService) {
        this.ecommerceService = ecommerceService;
        this.productOrders = [];
        this.products = [];
        this.productSelected = false;
    }
    ProductsComponent.prototype.ngOnInit = function () {
        this.productOrders = [];
        this.loadProducts();
        this.loadOrders();
    };
    ProductsComponent.prototype.addToCart = function (order) {
        this.ecommerceService.SelectedProductOrder = order;
        this.selectedProductOrder = this.ecommerceService.SelectedProductOrder;
        this.productSelected = true;
    };
    ProductsComponent.prototype.removeFromCart = function (productOrder) {
        var index = this.getProductIndex(productOrder.product);
        if (index > -1) {
            this.shoppingCartOrders.productOrders.splice(this.getProductIndex(productOrder.product), 1);
        }
        this.ecommerceService.ProductOrders = this.shoppingCartOrders;
        this.shoppingCartOrders = this.ecommerceService.ProductOrders;
        this.productSelected = false;
    };
    ProductsComponent.prototype.getProductIndex = function (product) {
        return this.ecommerceService.ProductOrders.productOrders.findIndex(function (value) { return value.product === product; });
    };
    ProductsComponent.prototype.isProductSelected = function (product) {
        return this.getProductIndex(product) > -1;
    };
    ProductsComponent.prototype.loadProducts = function () {
        var _this = this;
        this.ecommerceService.getAllProducts()
            .subscribe(function (products) {
            _this.products = products;
            _this.products.forEach(function (product) {
                _this.productOrders.push(new _models_product_order_model__WEBPACK_IMPORTED_MODULE_1__["ProductOrder"](product, 0));
            });
        }, function (error) { return console.log(error); });
    };
    ProductsComponent.prototype.loadOrders = function () {
        var _this = this;
        this.sub = this.ecommerceService.OrdersChanged.subscribe(function () {
            _this.shoppingCartOrders = _this.ecommerceService.ProductOrders;
        });
    };
    ProductsComponent.prototype.reset = function () {
        this.productOrders = [];
        this.loadProducts();
        this.ecommerceService.ProductOrders.productOrders = [];
        this.loadOrders();
        this.productSelected = false;
    };
    ProductsComponent = __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["Component"])({
            selector: 'app-products',
            template: __webpack_require__(/*! ./products.component.html */ "./src/app/ecommerce/products/products.component.html"),
            styles: [__webpack_require__(/*! ./products.component.css */ "./src/app/ecommerce/products/products.component.css")]
        }),
        __metadata("design:paramtypes", [_services_EcommerceService__WEBPACK_IMPORTED_MODULE_2__["EcommerceService"]])
    ], ProductsComponent);
    return ProductsComponent;
}());



/***/ }),

/***/ "./src/app/ecommerce/services/EcommerceService.ts":
/*!********************************************************!*\
  !*** ./src/app/ecommerce/services/EcommerceService.ts ***!
  \********************************************************/
/*! exports provided: EcommerceService */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "EcommerceService", function() { return EcommerceService; });
/* harmony import */ var rxjs_internal_Subject__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! rxjs/internal/Subject */ "./node_modules/rxjs/internal/Subject.js");
/* harmony import */ var rxjs_internal_Subject__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(rxjs_internal_Subject__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var _models_product_orders_model__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../models/product-orders.model */ "./src/app/ecommerce/models/product-orders.model.ts");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (undefined && undefined.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};




var EcommerceService = /** @class */ (function () {
    function EcommerceService(http) {
        this.http = http;
        this.productsUrl = "/api/products";
        this.ordersUrl = "/api/orders";
        this.orders = new _models_product_orders_model__WEBPACK_IMPORTED_MODULE_1__["ProductOrders"]();
        this.productOrderSubject = new rxjs_internal_Subject__WEBPACK_IMPORTED_MODULE_0__["Subject"]();
        this.ordersSubject = new rxjs_internal_Subject__WEBPACK_IMPORTED_MODULE_0__["Subject"]();
        this.totalSubject = new rxjs_internal_Subject__WEBPACK_IMPORTED_MODULE_0__["Subject"]();
        this.ProductOrderChanged = this.productOrderSubject.asObservable();
        this.OrdersChanged = this.ordersSubject.asObservable();
        this.TotalChanged = this.totalSubject.asObservable();
    }
    EcommerceService.prototype.getAllProducts = function () {
        return this.http.get(this.productsUrl);
    };
    EcommerceService.prototype.saveOrder = function (order) {
        return this.http.post(this.ordersUrl, order);
    };
    Object.defineProperty(EcommerceService.prototype, "SelectedProductOrder", {
        get: function () {
            return this.productOrder;
        },
        set: function (value) {
            this.productOrder = value;
            this.productOrderSubject.next();
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(EcommerceService.prototype, "ProductOrders", {
        get: function () {
            return this.orders;
        },
        set: function (value) {
            this.orders = value;
            this.ordersSubject.next();
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(EcommerceService.prototype, "Total", {
        get: function () {
            return this.total;
        },
        set: function (value) {
            this.total = value;
            this.totalSubject.next();
        },
        enumerable: true,
        configurable: true
    });
    EcommerceService = __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_3__["Injectable"])(),
        __metadata("design:paramtypes", [_angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpClient"]])
    ], EcommerceService);
    return EcommerceService;
}());



/***/ }),

/***/ "./src/app/ecommerce/shopping-cart/shopping-cart.component.css":
/*!*********************************************************************!*\
  !*** ./src/app/ecommerce/shopping-cart/shopping-cart.component.css ***!
  \*********************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = ""

/***/ }),

/***/ "./src/app/ecommerce/shopping-cart/shopping-cart.component.html":
/*!**********************************************************************!*\
  !*** ./src/app/ecommerce/shopping-cart/shopping-cart.component.html ***!
  \**********************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<div class=\"card text-white bg-danger mb-3\" style=\"max-width: 18rem;\">\n    <div class=\"card-header text-center\">Shopping Cart</div>\n    <div class=\"card-body\">\n        <h5 class=\"card-title\">Total: ${{total}}</h5>\n        <hr>\n        <h6 class=\"card-title\">Items bought:</h6>\n\n        <ul>\n            <li *ngFor=\"let order of orders.productOrders\">\n                {{ order.product.name }} - {{ order.quantity}} pcs.\n            </li>\n        </ul>\n\n        <button class=\"btn btn-light btn-block\" (click)=\"finishOrder()\"\n                [disabled]=\"orders.productOrders.length == 0\">Checkout\n        </button>\n    </div>\n</div>\n"

/***/ }),

/***/ "./src/app/ecommerce/shopping-cart/shopping-cart.component.ts":
/*!********************************************************************!*\
  !*** ./src/app/ecommerce/shopping-cart/shopping-cart.component.ts ***!
  \********************************************************************/
/*! exports provided: ShoppingCartComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "ShoppingCartComponent", function() { return ShoppingCartComponent; });
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _models_product_orders_model__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../models/product-orders.model */ "./src/app/ecommerce/models/product-orders.model.ts");
/* harmony import */ var _models_product_order_model__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../models/product-order.model */ "./src/app/ecommerce/models/product-order.model.ts");
/* harmony import */ var _services_EcommerceService__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../services/EcommerceService */ "./src/app/ecommerce/services/EcommerceService.ts");
var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (undefined && undefined.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};




var ShoppingCartComponent = /** @class */ (function () {
    function ShoppingCartComponent(ecommerceService) {
        this.ecommerceService = ecommerceService;
        this.total = 0;
        this.orderFinished = false;
        this.onOrderFinished = new _angular_core__WEBPACK_IMPORTED_MODULE_0__["EventEmitter"]();
    }
    ShoppingCartComponent.prototype.ngOnInit = function () {
        this.orders = new _models_product_orders_model__WEBPACK_IMPORTED_MODULE_1__["ProductOrders"]();
        this.loadCart();
        this.loadTotal();
    };
    ShoppingCartComponent.prototype.calculateTotal = function (products) {
        var sum = 0;
        products.forEach(function (value) {
            sum += (value.product.price * value.quantity);
        });
        return sum;
    };
    ShoppingCartComponent.prototype.ngOnDestroy = function () {
        this.sub.unsubscribe();
    };
    ShoppingCartComponent.prototype.finishOrder = function () {
        this.orderFinished = true;
        this.ecommerceService.Total = this.total;
        this.onOrderFinished.emit(this.orderFinished);
    };
    ShoppingCartComponent.prototype.loadTotal = function () {
        var _this = this;
        this.sub = this.ecommerceService.OrdersChanged.subscribe(function () {
            _this.total = _this.calculateTotal(_this.orders.productOrders);
        });
    };
    ShoppingCartComponent.prototype.loadCart = function () {
        var _this = this;
        this.sub = this.ecommerceService.ProductOrderChanged.subscribe(function () {
            var productOrder = _this.ecommerceService.SelectedProductOrder;
            if (productOrder) {
                _this.orders.productOrders.push(new _models_product_order_model__WEBPACK_IMPORTED_MODULE_2__["ProductOrder"](productOrder.product, productOrder.quantity));
            }
            _this.ecommerceService.ProductOrders = _this.orders;
            _this.orders = _this.ecommerceService.ProductOrders;
            _this.total = _this.calculateTotal(_this.orders.productOrders);
        });
    };
    ShoppingCartComponent.prototype.reset = function () {
        this.orderFinished = false;
        this.orders = new _models_product_orders_model__WEBPACK_IMPORTED_MODULE_1__["ProductOrders"]();
        this.orders.productOrders = [];
        this.loadTotal();
        this.total = 0;
    };
    __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["Output"])(),
        __metadata("design:type", _angular_core__WEBPACK_IMPORTED_MODULE_0__["EventEmitter"])
    ], ShoppingCartComponent.prototype, "onOrderFinished", void 0);
    ShoppingCartComponent = __decorate([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["Component"])({
            selector: 'app-shopping-cart',
            template: __webpack_require__(/*! ./shopping-cart.component.html */ "./src/app/ecommerce/shopping-cart/shopping-cart.component.html"),
            styles: [__webpack_require__(/*! ./shopping-cart.component.css */ "./src/app/ecommerce/shopping-cart/shopping-cart.component.css")]
        }),
        __metadata("design:paramtypes", [_services_EcommerceService__WEBPACK_IMPORTED_MODULE_3__["EcommerceService"]])
    ], ShoppingCartComponent);
    return ShoppingCartComponent;
}());



/***/ }),

/***/ "./src/environments/environment.ts":
/*!*****************************************!*\
  !*** ./src/environments/environment.ts ***!
  \*****************************************/
/*! exports provided: environment */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "environment", function() { return environment; });
// This file can be replaced during build by using the `fileReplacements` array.
// `ng build ---prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.
var environment = {
    production: false
};
/*
 * In development mode, to ignore zone related error stack frames such as
 * `zone.run`, `zoneDelegate.invokeTask` for easier debugging, you can
 * import the following file, but please comment it out in production mode
 * because it will have performance impact when throw error
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.


/***/ }),

/***/ "./src/main.ts":
/*!*********************!*\
  !*** ./src/main.ts ***!
  \*********************/
/*! no exports provided */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/platform-browser-dynamic */ "./node_modules/@angular/platform-browser-dynamic/fesm5/platform-browser-dynamic.js");
/* harmony import */ var _app_app_module__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./app/app.module */ "./src/app/app.module.ts");
/* harmony import */ var _environments_environment__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./environments/environment */ "./src/environments/environment.ts");




if (_environments_environment__WEBPACK_IMPORTED_MODULE_3__["environment"].production) {
    Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["enableProdMode"])();
}
Object(_angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_1__["platformBrowserDynamic"])().bootstrapModule(_app_app_module__WEBPACK_IMPORTED_MODULE_2__["AppModule"])
    .catch(function (err) { return console.log(err); });


/***/ }),

/***/ 0:
/*!***************************!*\
  !*** multi ./src/main.ts ***!
  \***************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(/*! /tmp/tutorials/spring-boot-angular-ecommerce/src/main/frontend/src/main.ts */"./src/main.ts");


/***/ })

},[[0,"runtime","vendor"]]]);
//# sourceMappingURL=main.js.map