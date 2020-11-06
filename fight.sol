// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;
import "./openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./openzeppelin-solidity/contracts/access/Ownable.sol";

contract fight{

    event showstatus();
    /* show hp */
    event victory();
    /* annonce le gagnant */

    function random(uint mod) internal view returns(uint){
        /* random till mod */
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % mod;
        return rand;
    }

    function whoStart() view internal returns (uint){
        /* 1 or 2 */
        uint random =  random(2) ;
        return random+1;
    }

    function hitChance (Brute _attacker, Brute _defender ) view internal returns (bool chance, uint code){
        /* hit or miss?  */

        bool yes;
        uint code;
        uint rand1 = random(101);
        uint rand2 = random(101);
        if (_perso1.hitChance > rand1){
            if (_perso2.agility <rand2){
                yes = true;
                code = 1;
                return(yes, code);
                /* j1 reussit son coup, j2 n'esquive pas, renvoie true et code 1 = reussit */
            } else {
                yes= false;
                code= 3;
                return (yes, code);
                /* j1 reussit son coup, j2 esquive, renvoie false et code 3 = esquive */
            }
        } else {
            yes= false;
            code= 2;
            return (yes, code);
            /* j1 rate son coup, renvoie false et code 2 = coup manqué */
        }
    }

    function attack (Brute _attacker, Brute _defender, uint hpDef ) view internal returns(uint){
        /* a single attack */
        uint critical= random(101);
        bool chance;
        uint code;
        (chance, code)= hitChance(_attacker, _defender);

        if(critical <= 30){
            chance == true;
            uint hpleft= hpDef - (_attacker.attack*1.5);
            emit showstatus(chance, _defender.hp);
            return hpleft;
        }
        if (chance == true){
            uint hpWound = uint(_attacker.attack - _defender.defense);
            uint hpleft=  hpDef - hpWound;
            emit showstatus(chance, _defender.hp);
            return hpleft;
        }
        else{
            emit showstatus(chance, _defender.hp);
            return hpstart;
        }

    }


    function fight(Brute _agressor, Brute _victim) public returns (string memory){ 
        /* all attacks till death  */

        uint hpAttac = _agressor.hp;
        uint hpDef = _victim.hp;
        if (whostart()==1){             /* l'attaquant attaque en premier */
            while (hpAttac > 0 && hpDef > 0){
                hpDef = attack( _agressor, _victim, hpDef);
                if (hpdef <= 0) { 
                    emit victory(_agressor);
                    return ("j2 est mort");
                }
                hpAttack = attack( _victim, _agressor, hpAttack);            
                emit victory(_victim);
                return ("le j1 il est dead");
            }
        } else {              /* le defenseur attaque en premier */
            while (hpAttac > 0 && hpDef > 0){
                hpAttack= attack( _victim, _agressor, hpAttack);
                if (hpAttac <= 0) { 
                    emit victory(_victim);
                    return ("j1 est mort"); 
                }
                hpDef = attack( _agressor, _victim, hpDef);
                }
            }
            emit victory(_agressor);
            return ("le j2 il est dead");
        }
    }
}
