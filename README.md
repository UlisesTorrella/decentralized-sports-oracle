# Decentralized Oracle for Football Tournaments

## The trigger

I've been trying to get into betting sites for a while, but struggled with the trust issues to make a initial deposit of 100+ dollars in a centralized website, with the known cons about it. Also, projects like [betswap](https://betswap.gg) come to mind, with the centralization compromise of using a third-party oracle. And there's the catch, do we trust Google informing us the result of a match, do we trust FIFA posting the real results of a World Cup match. Probably we do. They do run the show so they do have the privilege of holding the truth. But that's not what the crypto community is about. So I digged a little into the decentralized oracles proposals. 

## Staking Oracle

An Oracle is a input stream of the outside world into the blockchain. So we need people to operate this oracle, to come a say "Hey Argentina just won the world cup" (I hope), this information would be registered into the blockchain and if I have a bet on Argentina when the newly acquire information is minted I can cash my earnings with the security provided by the network. 

And what about the lairs? That what staking is for, I assume you know the PoS mechanism, this project aims to implement a PoS mechanism to confirm what we call Announcements. Stakers, or informers, will be announcing events in the tournament, confirming a peer's events or disproving a fake announcement. 

This will provide decentralized information about different kind of sports event to be available in the network with our relying on off-chain data. And this has value, so do the work our informers provide.

Then if you inform, and say the truth (according to the half+1 of the population) you deserve to be awarded. That's where the token comes to play.

## The Token

Our token (yet to be named, and no @[lautarolecumberry](https://github.com/lautarolecumberry), it won't be LECU) are what stakers get paid for working for the oracle. So it's only fair that they can use it for betting purposes. That's why this is the same casino token we will use in our betting contract. Stakers can work for the community, be rewarded and use this  reward to play, or sell to users that don't feel like working. 

This project is not aim for millionaires to come and deposit thousands of dollars and betting loads of money. This is a base layer of abstract classes to be expanded into contracts that represent Tournaments, with their own token, stakers and announcements. 

## The Scope

The token will be as valuable as the amount of work the informers put into the Oracle, based on the value the Oracle reaches by it's utility (in this project, just for bets). Then, we cannot use the same token for basketball matches, football matches, world cup tournaments that only happens 1 every 4 years and yearly tournaments. That's why the scope of a Token will be it's own tournament.

The way the contracts are written allow people to just implement them in a smaller scale, for example a regional tournament, and of course the number of informers will be less than the people interested in the World Cup. So the *half+1* should not be taken from the total of stakers in the ecosystem. That's why the scope of the Oracle will be it's own tournament.

## POC: The FIFA World Cup

As a proof of concept we will be implementing and deploying a contract in the polygon network to work as an Oracle for the FIFA World Cup, allowing users to bet on *team **x **wins* or *team **y** wins*. 



# How does it work

## Oracle

The oracle contract holds **Teams** and **Games** structures in storage. This start out empty and will be filled by users. 

Also, an oracle has a **Staking** contract attached, where people can stake their coins and become informants. As an informant they will be allowed to announce, approve announcements or disprove announcements. **Announcements** will be stored in the Oracle, in queued to be **solidified**, once solidified the announcement will make changes to the state of the oracle. 

As informers each have a vote in an Announcement, that's why there is a minimum staking amount. This minimum will grow based on the amount of already registered stakers. Given that the value of the Oracle will be proportional to the amount of people giving information, therefor the state of the Oracle is more trust worthy, if you want to corrupt the Oracle making a 50% attack you will have to stake a large amount of money proportional to the value of the Oracle. 

## Bookie

A bookie is a very simple contract that provides confidence to hold your tokens, and distribute the returns fairly using our Oracle as source of truth. This bookie will not charge any commission and the user will only have to pay for the gas fees, that's why a sidechain is probably the best option for this kind of systems.

