use rsa::{PublicKey, RSAPublicKey};
use base64::decode;

fn main() {
    // Sample signed messages and their corresponding public keys
    let messages = vec![
        "Message 1",
        "Message 2",
        "Message 3",
    ];

    let signatures = vec![
        "8e88b1e3e9a3d8ce0f53ca4c0381a5a0d6d50eef4e8d15d34e0acaf97e9035e0ce52d7a01d9a9f8d3d3b191eeb06d216c0a32d784f6b4381a2a6d686a72dbd35c",
        "a5293ed635ea6dbd9ed63157b2d15d68598e58c68dd97e8803d287d194d5b123ea65f8d002ee7c8275ec6569acdb3b74f65a1f46e6bc981894f75c9a98f2b3b4",
        "f39e325dbd8e5f56e5b03edf3ff77411efbde84e5e1ec0f9bbfa9a56ff71eac092c3df53420ce7fb217de34215d47888d7f07a2ec5a8dd68669dca862cb5a5ca",
    ];

    let public_keys = vec![
        "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzIfzouqS0UW9VnUBVc7EfLLTzN+kfUsAAHf3j1FmsMcMM/G2KRy32m6V8i7A8q38se30qUgo8Q5g6uS19RzTRFc6r+eybUmbDzrptWuq3+0hQWx1Xu74SXf7EDOa9eqnpiB2NT0CwCEj7gP6kUIyHA2CMh0K9c2MW95YO18RdsqZgWztnHaknU+KzzNSCw45Blz72lM4xATl4y/THoCZ44e3sgtyNTw7LXRRaJL7wAV92tm6qEYnZ6x5dRmWvVr6LzscovSiRz8dN2T3XrWapubwdNk/EW/ttQjOXIqEGxkZRPlhD5ObSaPO5dE5Fk6Rk/4p5HZ7d9kLyV9R4JGEXbwIDAQAB",
        "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1dErU8jORiIcRAakY4Vsw26VvdslTqITsFpSg2ex1Dfrh7yy1ZzTzgxEiPJxNEOc3LV3ZtZs/3BHZXLXsgAqxKxuvluYvIklAD9juMRdW1HP2AblcKAsWzv/UFRxWvX6FuBtLb/VbLhaAQym2GB/qtKQVtjb/TSd1eObqqmuXwSOyEbCZmR4R99l9nK6nI0io1MXTBk9wySLVJvTQUswBAr3RlTjHz7xwMz0Hv5esLEf1D/1MJijcRo//6TlKJt54Xrh91iGfFNLtHdPhrji9x1X9+OaEi0AXJ0shNyXkkYJkPcRqBcSfwHOknOf5eFXnLz5EDSDZpMoJFbXN/EJywIDAQAB",
        "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlmaqWGoRtc1fV6F2wa7wemlpgQmuztNAD7IBBz99u86veKlJ86K72v4rvTMngsL3FD2oC4OVMQjiEZf1z80yS6JtM05JBN7b74u2e+pKW5YYcCVaxhzmDmwHKXYHPa6Lj7UUrXut3T+Vb5BDi5UkCzD+QvDln6ZtvZZtV/e5Lwe+2FDInBcNXoikv/Fkt63vFlzWcoWzwcdHZV5n4ukq0X3UwsUqQb13USi33+rmUJGZ5/0jCt1RjYhrq8h0GAKfu/5qLXF6I5etx2T++TLC/jE4RS0AzRc9He4isPEz6fgrWf7pOrDIN5m9TkKkuqkvJGYhz9jOfbAik5L/fxNwIDAQAB",
    ];

    for i in 0..messages.len() {
        let is_valid = verify_signature(&public_keys[i], messages[i], signatures[i]);
        if is_valid {
            println!("Message {} is VALID", i + 1);
        } else {
            println!("Message {} is NOT VALID", i + 1);
        }
    }
}

fn verify_signature(public_key_base64: &str, message: &str, signature: &str) -> bool {
    let public_key_bytes = match base64::decode(public_key_base64) {
        Ok(bytes) => bytes,
        Err(_) => return false,
    };

    let public_key = match RSAPublicKey::from_pkcs1(&public_key_bytes) {
        Ok(key) => key,
        Err(_) => return false,
    };

    let signature_bytes = match base64::decode(signature) {
        Ok(bytes) => bytes,
        Err(_) => return false,
    };

    if public_key.verify(rsa::padding::PKCS1v15, &message.as_bytes(), &signature_bytes).is_ok() {
        true
    } else {
        false
    }
}
