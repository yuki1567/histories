const initPostCodeJp = () => {
  if (document.getElementById('borrow_address_postal_code')) {
    const PostCodeJp = new postcodejp.address.AutoComplementService(process.env.POSTCODEJP_API_KEY);
    const postal_code = document.getElementById("borrow_address_postal_code");
    const prefecture = document.getElementById("prefecture");
    const city = document.getElementById("borrow_address_city");
    const street_address = document.getElementById("borrow_address_street_address");
    
    PostCodeJp.setZipTextbox(postal_code);
    PostCodeJp.add(new postcodejp.address.StateSelectbox(prefecture).byText());
    PostCodeJp.add(new postcodejp.address.TownTextbox(city));
    PostCodeJp.add(new postcodejp.address.StreetTextbox(street_address));
    PostCodeJp.observe();
  };
};

window.addEventListener("load", initPostCodeJp);