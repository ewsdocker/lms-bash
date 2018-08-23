# *********************************************************************************
# *********************************************************************************
#
#   llrbTree.bash
#
#		Left-Leaning Red-Black Tree
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.0.1
# @copyright © 2016. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage llrbNode
#
# *****************************************************************************
#
#	Copyright © 2016. EarthWalk Software
#	Licensed under the Academic Free License, version 3.0.
#
#	Refer to the file named License.txt provided with the source,
#	or from
#
#			http://opensource.org/licenses/academic.php
#
# *****************************************************************************
#
#			Version 0.0.1 - 04-01-2016.
#
# *********************************************************************************
# *********************************************************************************

declare -A lmsllrb_TVTable=()			# treeName = treeUid

declare    lmsllrb_TVUid=""				# current tree uid (after lookup)
declare    lmsllrb_TVName=""			# current tree name
declare    lmsllrb_TVRoot=""			# current tree root

declare    lmsllrb_TVNode=""			# temporary node for key search/insertion

declare    lmsllrb_TVStack="TreeStack"	# name of the recursion stack
declare    lmsllrb_TVStackUid=""		# name of the recursion stack

#
#	Each tree structure will have the following variables automatically declared:
#
#declare	lmsllrb_TVRoot_UID			# the key for the root node
#declare	lmsllrb_TVNodes_UID			# number of nodes in the tree

# ***********************************************************************************************************
#
#	llrbTreeCreate
#
#		Create a new llrb tree and initialize the entries
#
#	parameters:
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# *********************************************************************************
function llrbTreeCreate()
{
	lmsllrb_TVName=$1
	lmsllrb_TVUid=""

	llrbTreeLookup "${lmsllrb_TVName}" lmsllrb_TVUid
	if [[ $? -ne 1 ]]
	then
		lmsErrorQWrite $LINENO NodeCreate "Node '${lmsllrb_TVName}' already exists, uid = '${lmsllrb_TVUid}'"
		return 1
	fi

	lmsUIdUnique lmsllrb_TVUid
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeCreate "Unable to get Unique id"
		return $?
	fi

	lmsllrb_TVTable["${lmsllrb_TVName}"]="$lmsllrb_TVUid"

	lmsDeclareStr "lmsllrb_TVRoot_${lmsllrb_TVUid}" "0"
	llrbTreeRoot "$lmsllrb_TVName"

	lmsStackCreate $lmsllrb_TVStack lmsllrb_TVStackUid
	if [[ $? -ne 0 ]]
	then
		return 1
	fi

	return 0
}

# ***********************************************************************************************************
#
#	llrbTreeCreateNode
#
#		Create a new (temporary) node
#
#	parameters:
#		treeName = name of the tree to create keynode for
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# *********************************************************************************
function llrbTreeCreateNode()
{
	llkey="${1}"
	lldata=${2:-0}

	local llUid=""

	llUid=$( llrbNodeLookup "${llkey}" )
	if [[ $? -eq 1 ]]
	then
		llrbNodeSet ${llkey} "data" "${lldata}"
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeKeynode "Unable to create node for '${llkey}'."
			return 1
		fi

		lmsErrorQReset	  # ignore node errors, such as 'not found' before it was created
		return 2
	fi

	llrbNodeCreate "${llkey}" llUid "${lldata}"
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeKeynode "Unable to create node for '${llkey}'."
		return 1
	fi

	lmsErrorQReset		# ignore node errors, such as 'not found' before it was created
	return 0
}

# ***********************************************************************************************************
#
#	llrbTreeLookup
#
#		get the llrbTree key uid
#
#	parameters:
#		name = the name of the tree to search for
#
#	outputs:
#		uid = llrbTree Uid
#
#	returns:
#		0 = found in table, uid is valid
#		1 = not found in table, uid is invalid
#
# *********************************************************************************
function llrbTreeLookup()
{
	local llrbTName="${1}"

	[[ -z "${llrbTreeTable[$llrbTName]}" ]] && return 1

	lmsllrb_TVName="$llrbTName"
	lmsllrb_TVUid="$llrbTreeTable[$llrbTName]"
	lmsllrb_TVRoot="$lmsllrb_TVRoot_$lmsllrb_TVUid"

	if [[ -n "${2}" ]]
	then
		eval ${2}="'$lmsllrb_TVUid'"
	else
		echo "$lmsllrb_TVUid"
	fi

	return 0
}

# *********************************************************************************
#
#	llrbTreeRoot
#
#		Set the root value for the selected tree
#
#	Parameters:
#		treeName = name of the tree to set root for
#		root     = root value to set selected tree root to
#					(if empty, sets root to selected tree root)
#
#	Returns:
#		0 = no error
#		1 = error occurred
#
# *********************************************************************************
function llrbTreeRoot()
{
	local lltree="${1:-$lmsllrb_TVName}"
	local llroot="${2}"
	local llUid

	if [[ -n "$llroot" ]]
	then
		eval "lmsllrb_TVRoot_${lmsllrb_TVUid}='${llroot}'"
	else
		eval 'lmsllrb_TVRoot=$'"{lmsllrb_TVRoot_$lmsllrb_TVUid}"
	fi

	return 0
}

# *********************************************************************************
# *********************************************************************************

# *********************************************************************************
#
#	llrbTreeFlipColors
#
#		Flip the colors of the node and it's 2 children (if they exist)
#
#	parameters:
#		node = the name of the node to flip colors in
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTreeFlipColors()
{
	local llnode="$1"
	local llchild
	local llcolor

	llrbNode_Field $llnode "color" llcolor
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFlipColors "Unable to get color for '$llnode'."
		return 1
	fi

	let llcolor=($llcolor+1)%2
	llrbNode_Field $llnode "color" llcolor $llcolor
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFlipColors "Unable to set color for '$llnode'."
		return 1
	fi

	llrbNode_Field $llnode "left" llchild
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFlipColors "Unable to get left child for '$llnode'."
		return 1
	fi

	if [[ "${llchild}" != "0" ]]
	then
		llrbNode_Field $llchild "color" llcolor
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFlipColors "Unable to get color for '$llchild'."
			return 1
		fi

		let llcolor=($llcolor+1)%2

		llrbNode_Field $llchild "color" llcolor $llcolor
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFlipColors "Unable to set color for '$llchild'."
			return 1
		fi
	fi

	llrbNode_Field $llnode "right" llchild
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFlipColors "Unable to get right child for '$llnode'."
		return 1
	fi

	if [[ "${llchild}" != "0" ]]
	then
		llrbNode_Field $llchild "color" llcolor
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFlipColors "Unable to get color of right child of '$llchild'."
			return 1
		fi

		let llcolor=($llcolor+1)%2
		llrbNode_Field $llchild "color" llcolor $llcolor
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFlipColors "Unable to set color of right child of '$llchild'."
			return 1
		fi
	fi

	return 0
}

# *********************************************************************************
#
#	llrbTreeInsert
#
#		Insert the node into the tree defined by the root, then balance the tree.
#
#	parameters:
#		key = name of the key to insert into the tree
#		data = (optional) data to insert into the node
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTreeInsert()
{
	local llkey="${1}"
	local lldata="${2}"

	local llroot
	local llnode

	llrbNodeCreate "$llkey" llnode "$lldata"
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeInsert "Unable to create node for '${llkey}'"
		return 1
	fi
lmsConioDisplay "$( llrbNodeToString $llnode )"

	llrbTreeInsertNode $llnode $lmsllrb_TVRoot llroot
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeInsert "Unable to insert node '${llkey}' into the tree"
		return 1
	fi

echo "set $llroot color: $lmsllrb_NodeBLACK"
lmsConioDisplay "$( llrbNodeToString $llroot )"

errorQueueDisplay 1 0 EndOfTest

	llrbNode_Field $llroot "color" $lmsllrb_NodeBLACK
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeInsert "Unable to set '${llroot}' color"
		return 1
	fi

echo "llroot: $llroot, lmsllrb_TVName = $lmsllrb_TVName"
	llrbTreeRoot "$lmsllrb_TVName" "$llroot"
echo "lmsllrb_TVRoot: $lmsllrb_TVRoot"

	return 0
}

	#protected function insertNode($root, $node)
	#{
	#	if ($root == null)
	#	{
	#		$this->nodes++;
	#		return new LLRBTree\LLRBNode($node->key(), $node->data(), $this->tdetail);
	#	}
	#
	#	switch($root->compare($node))
	#	{
	#	case 0:  // equal
	#		$root->data($node->data());
	#		break;
	#
	#	case -1: // less
	#		$root->left($this->insertNode($root->left(), $node));
	#		break;
	#
	#	case 1:  // greater
	#		$root->right($this->insertNode($root->right(), $node));
	#		break;
	#	}
	#
	#	return $this->fixUp($root);
	#}


# *********************************************************************************
#
#	llrbTreeInsertNode
#
#		Insert the node into the tree defined by the root, then balance the tree.
#
#	parameters:
#		node = node to insert into the tree
#		root = root node of the tree (or branch)
#		balanced = new root after balancing
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTreeInsertNode()
{
	local llnode=$1
	local llroot=$2

	local llbranch
	local llchild
	local llresult
	local lldata

lmsConioDisplay "Insert Node: llnode: $llnode"
lmsConioDisplay " $( llrbNodeToString $llnode ) "

	if [[ "${llroot}" == "0" ]]
	then
		x="uid"
		llrbNode_Field "$llnode" $x llbranch

errorQueueDisplay 1 1 EndOfTest

		lmsConioDisplay "InsertNode copy -- $llnode to $llbranch"

		llrbNode_Field $llroot 'left' "0"
		llrbNode_Field $llroot 'right' "0"
		llrbNode_Field $llroot 'color' $lmsllrb_NodeBLACK

lmsConioDisplay "Root: $llroot"
lmsConioDisplay "$( llrbNodeToString $llroot )"

		eval "${3}='${llroot}'"
		return 0
	fi

echo "NodeCompare $llnode with $llroot"

	llrbNodeCompare $llnode $llroot
	if [[ $? -lt 0  || $? -gt 2 ]]
	then
		lmsErrorQWrite $LINENO TreeInsertNode "llrbNodeCompare returned '$?'."
		return 1
	fi

	llresult=$?

	if [ $llresult -eq 0 ]
	then
		lldata=$( llrbNodeGet "$llnode" "key" )
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeInsertNode "llrbNodeGet failed for '$llnode'."
			return 1
		fi

		llrbNodeSet $llroot "key" $lldata
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeInsertNode "llrbNodeSet failed for '$llroot'."
			return 1
		fi
	else
		# ##################################################################
		#
		#	llnode > llroot
		#
		#		$root->left($this->insertNode($root->left(), $root));
		#
		#	llnode < llroot
		#
		#		$root->right($this->insertNode($root->right(), $root));
		#
		# ##################################################################

		llrbTree_PushNodes "$llnode" "$llroot"
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeInsertNode "Unable to push '$llnode' and '$llroot' on the stack."
			return 1
		fi

		if [ $llresult -eq 1 ]
		then
			llbranch="right"
		else
			llbranch="left"
		fi

		llchild=$( llrbNodeGet "$llroot" "$llbranch" )
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeInsertNode "Unable to get $branch child of '$llroot'."
			return 1
		fi

		llrbTreeInsertNode $llchild $llnode llchild
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeInsertNode "Unable to insert '$llchild' node as child of '$llnode'."
			return 1
		fi

		llrbTree_PopNodes llnode llroot
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeInsertNode "Unable to pop '$llnode' and '$llroot' from the stack."
			return 1
		fi

		llrbNodeSet $llroot "$llbranch" $llchild
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeInsertNode "llrbNodeSet failed for '$llroot'."
			return 1
		fi
	fi

	llrbTreeFixUp $llroot llroot
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeInsertNode "llrbTreeFixUp failed for '$llroot'."
		return 1
	fi

	eval "${3}='${llroot}'"

	return 0
}

# *********************************************************************************
#
#	llrbTreeFixUp
#
#		Balance the tree and fix up the colors on the way up the tree.
#
#	parameters:
#		root = root node of the tree (or branch) to balance
#		deleteOk = 1 if deleting a key node, 0 otherwise
#		fixed = contains the new root of the fixed up tree
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTreeFixUp()
{
	local llnode=$1
	local lldelete=${2:-0}

	local llcolor

	local llchild=$( llrbNodeGet $llnode "right" )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFixUp "llrbNodeGet failed to get 'right' child for '$llnode'."
		return 1
	fi

	llcolor=$( llrbTreeIsRedNode $llnode )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFixUp "llrbIsRed failed to get 'right' child for '$llnode'."
		return 1
	fi

	if [[ $llcolor -eq $llrbNode_Red ]]
	then
		llchild=$( llrbNodeGet $llnode "left" )
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFixUp "llrbNodeGet failed to get 'left' child for '$llnode'."
			return 1
		fi
	fi

	llcolor=$( llrbTreeIsRedNode $llchild )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFixUp "llrbTreeIsRedNode failed to get child for '$llchild'."
		return 1
	fi

	let llcolor=($llcolor+1)%2
	let llcolor+=$lldelete

	if (( ( $lldelete -eq 1) )) || (( ( $llcolor -eq $lmsllrb_NodeBLACK ) ))
	then
		llrbTreeRotateLeft $llnode llnode
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFixUp "llrbRotateLeft failed to rotate '$llnode'."
			return 1
		fi

		llchild=$( llrbNodeGet $llnode "left" )
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFixUp "llrbNodeGet failed to load left child of '$llnode'."
			return 1
		fi

		llcolor=$( llrbTreeIsRedNode $llchild )
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFixUp "llrbIsRedNode failed to get color for '$llnode'."
			return 1
		fi

		if [[ $llcolor -eq $lmsllrb_NodeRED ]]
		then
			llchild=$( llrbNodeGet $llchild "left" )
			if [[ $? -ne 0 ]]
			then
				lmsErrorQWrite $LINENO TreeFixUp "llrbNodeGet failed to get left child for '$llchild'."
				return 1
			fi

			llcolor=$( llrbTreeIsRedNode $llchild )
			if [[ $? -ne 0 ]]
			then
				lmsErrorQWrite $LINENO TreeFixUp "llrbTreeIsRedNode failed for '$llchild'."
				return 1
			fi

			if [[ $llcolor -eq $lmsllrb_NodeRED ]]
			then
				llrbTreeRotateRight $llnode llnode
				if [[ $? -ne 0 ]]
				then
					lmsErrorQWrite $LINENO TreeFixUp "llrbRotateRight failed to rotate '$llnode'."
					return 1
				fi
			fi
		fi
	fi

	llchild=$( llrbNodeGet $llnode "left" )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFixUp "llrbNodeGet failed to load left child of '$llnode'."
		return 1
	fi

	llcolor=$( llrbTreeIsRedNode $llchild )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeFixUp "llrbIsRedNode failed to get color for '$llnode'."
		return 1
	fi

	if [[ $llcolor -eq $lmsllrb_NodeRED ]]
	then
		llchild=$( llrbNodeGet $llnode "right" )
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFixUp "llrbNodeGet failed to load right child of '$llnode'."
			return 1
		fi

		llcolor=$( llrbTreeIsRedNode $llchild )
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeFixUp "llrbIsRedNode failed to get color for '$llchild'."
			return 1
		fi

		if [[ $llcolor -eq $lmsllrb_NodeRED ]]
		then
			llrbTreeFlipColors $llnode
			if [[ $? -ne 0 ]]
			then
				lmsErrorQWrite $LINENO TreeFixUp "llrbTreeFlipColors failed to get color for '$llnode'."
				return 1
			fi
		fi
	fi

	eval "${3}='${llnode}'"
	return 0
}

# *********************************************************************************
#
#	llrbTreeIsRedNode
#
#		Check if the node is 'red'
#
#	parameters:
#		name   = the name of the tree to search for
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTreeIsRedNode()
{
	local llkey=$1
	local llcolor=0

	if [[ "$llkey" != "0" ]]
	then
		llcolor=$( llrbNodeGet "$llkey" "color" )
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO TreeModifyNode "Unable to get color from node '${llkey}' for tree '${llrbTName}'."
			return 1
		fi
	fi

	echo "${llcolor}"
}

# *********************************************************************************
#
#	llrbTreeRotateLeft
#
#		Rotate the current to the left
#
#	parameters:
#		name = the name of the tree
#		node = the node to be rotated
#		root = the return value is placed here
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTreeRotateLeft()
{
	local llnode=$1
	local llroot
	local llchild
	local llcolor

	llroot=$( llrbNodeGet $llnode "right" )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateLeft failed to get RIGHT for '$llnode'."
		return 1
	fi

	llchild=$( llrbNodeGet $llroot "left" )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateLeft failed to get left child for '$llroot'."
		return 1
	fi

	llrbNodeSet $llnode "left" $llchild
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateLeft failed to get left child for '$llchild'."
		return 1
	fi

	llrbNodeSet $llroot "left" $llnode
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateLeft failed to get left child for '$llroot'."
		return 1
	fi

	llcolor=$( llrbNodeGet $llnode "color" )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateLeft failed to get left child for '$llroot'."
		return 1
	fi

	llrbNodeSet $llroot "color" $llcolor
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateLeft failed to get left child for '$llroot'."
		return 1
	fi

	llrbNodeSet $llnode "color" $lmsllrb_NodeRED
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateLeft failed to get left child for '$llroot'."
		return 1
	fi

	eval '${2}='"llroot"

	return 0
}

# *********************************************************************************
#
#	llrbTreeRotateRight
#
#		Rotate the current to the right
#
#	parameters:
#		name = the name of the tree
#		node = the node to be rotated
#		root = the return value is placed here
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTreeRotateRight()
{
	local llnode=$1
	local llroot
	local llchild
	local llcolor

	llroot=$( llrbNodeGet $llnode "left" )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateRight failed to get LEFT for '$llnode'."
		return 1
	fi

	llchild=$( llrbNodeGet $llroot "right" )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateRight failed to get RIGHT for '$llroot'."
		return 1
	fi

	llrbNodeSet $llnode "left" $llchild
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateRight failed to set LEFT for '$llnode'."
		return 1
	fi

	llrbNodeSet $llroot "right" $llnode
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateRight failed to set IGHT for '$llnode'."
		return 1
	fi

	llcolor=$( llrbNodeGet $llnode "color" )
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateRight failed to get COLOR for '$llnode'."
		return 1
	fi

	llrbNodeSet $llroot "color" $llcolor
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateRight failed to get COLOR for '$llnode'."
		return 1
	fi

	llrbNodeSet $llnode "color" $lmsllrb_NodeRED
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO TreeRotate "llrbTreeRotateRight failed to get COLOR for '$llnode'."
		return 1
	fi

	eval '${2}='"llroot"
	return 0
}

# *********************************************************************************
# *********************************************************************************

# *********************************************************************************
#
#	llrbTree_PushNodes
#
#		Push the node and root names onto the recursion stack
#
#	parameters:
#		node = node to push
#		root = root to push
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTree_PushNodes()
{
	local pNode="$1"
	local pRoot="$2"

	lmsStackWrite $lmsllrb_TVStack "$pNode"
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO PushNodes "llrbTree_PushNodes failed to get LEFT for '$llnode'."
		return 1
	fi

	lmsStackWrite $lmsllrb_TVStack "$pRoot"
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO PushNodes "llrbTree_PushNodes failed to get LEFT for '$llnode'."
		return 1
	fi

	return 0
}

# *********************************************************************************
#
#	llrbTree_PopNodes
#
#		Pop the root and node names from the recursion stack
#
#	parameters:
#		node = popped node
#		root = popped root
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbTree_PopNodes()
{
	local pNode=$1
	local pRoot=$2

	local pchild

	lmsStackRead $lmsllrb_TVStack pchild
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO PopNodes "llrbTree_PopNodes failed to POP 'llroot' from the stack."
		return 1
	fi

	eval "${pRoot}='${pchild}'"

	lmsStackRead $lmsllrb_TVStack pchild
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO PopNodes "llrbTree_PopNodes failed to POP 'llnodes' from the stack."
		return 1
	fi

	eval "${pNode}='${pchild}'"

	return 0
}

# *********************************************************************************
# *********************************************************************************

