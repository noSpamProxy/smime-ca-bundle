# SMIME CA Bundle
Welcome to the NoSpamProxy SMIME CA Bundle repository! Use NoSpamproxy for e-mail security and encryption.  
This repository serves as a community-driven SMIME CA bundle. Everyone is welcome to create pull requests to add CA or sub-CA certificates. We will review and possibly discuss each request.  

**Please note** that we do not actively maintain the certificates themselves and are **not responsible for any of the provided certificates**.
Use them at your own risk.

## Structure
In order not to lose the overview, the repository has the following structure  
`certificatetype/companyname/yearofissue/certificatename-certificatsthumbprint.cer`  
e.g.  
`root/Net at Work/2024/MailCertificate_0x112233-974E423EE44A99FA98CFC46BCDCACA91E0A7FAD6.der  

### Intermediate
The `intermediaries` folder contains all intermediary CA certificates in the bundle.

### Root
The `root` folder contains all root CA certificates in the bundle.