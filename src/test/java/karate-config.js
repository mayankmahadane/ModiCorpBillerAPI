function fn() {
  var env = karate.env; // get system property 'karate.env'

  karate.log('karate.env system property was:', env);

  if (!env) {
    env = 'qa';
  }
  var config = {
    env: env,
    myVarName: 'someValue'
  }
  if (env == 'qa') {
    config.getBillersApiUrl = 'https://mastercard.biller.com/getbillers';
    config.getUnpaidBillApiUrl = 'https://mastercard.biller.com/getunpaidbill';
    config.payBillApiUrl = 'https://mastercard.biller.com/paybillfromwallet';
    config.rechargeWalletApiUrl = 'https://mastercard.biller.com/rechargewallet';
    config.registrationApiUrl = 'https://mastercard.biller.com/registeruser';
  } else if (env == 'stage') {

  }

  return config;
}