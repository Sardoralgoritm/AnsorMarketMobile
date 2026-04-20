class ApiConstants {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.ssardor.uz',
  );
  static const cdnBaseUrl = String.fromEnvironment(
    'CDN_BASE_URL',
    defaultValue: 'https://cdn.ssardor.uz',
  );

  // Auth
  static const register = '/api/Auth/Register';
  static const login = '/api/Auth/Login';
  static const refresh = '/api/Auth/Refresh';
  static const logout = '/api/Auth/Logout';

  // Products
  static const productsGetList = '/api/Products/GetList';
  static const productsGetById = '/api/Products/GetById';
  static const products = '/api/products';

  // Categories
  static const categoriesGetList = '/api/Categories/GetList';
  static const categoriesGetTree = '/api/Categories/GetTree';
  static const categories = '/api/categories';

  // Cart
  static const cart = '/api/cart';
  static const cartGetCart = '/api/cart/getcart';
  static const cartAddItem = '/api/cart/additem';
  static const cartClear = '/api/cart/clear';

  // Customer
  static const customerGetProfile = '/api/customer/getprofile';
  static const customerUpdateProfile = '/api/customer/updateprofile';
  static const customerChangePassword = '/api/customer/changepassword';

  // Branches
  static const branchesGetList = '/api/branches/getlist';
  static const branches = '/api/branches';
  static const branchesInRange = '/api/branches/in-range';
}
